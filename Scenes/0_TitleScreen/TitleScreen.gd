extends Control

onready var play_button = $PlayButton

onready var email = $Email
onready var password = $Password
onready var mistake = $Mistake
onready var nokey = $NoKey

var api_key
var http_request

var is_mistake = false

var checked_key = false
var has_key = false

func _init():
	## get api key
	var file = File.new()
	file.open("res://.env", File.READ)
	api_key = parse_json(file.get_as_text()).api_key
	file.close()
	
func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	play_button.connect("pressed", self, "_login_pressed")
	http_request.connect("request_completed", self, "_on_request_completed")

func _input(event):
	if event.is_action_pressed("enter"):
		_login_pressed()
	
	if event.is_action_pressed("escape"):
		get_tree().quit()
	
func _login_pressed():
	var body = { "Email": email.text, "Password": password.text}
	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	headers.append("SecretHeaderAPIKey: " + api_key)
	var error = http_request.request("https://api-internal.vulcanforged.com/MyForge/Auth", headers, false, HTTPClient.METHOD_POST, query)

	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _process(delta):
	mistake.visible = is_mistake
	if checked_key and not has_key:
		nokey.visible = true
	else:
		nokey.visible = false
func _get_geokey(address):
	var geoUrl = "http://api.vulcanforged.com/getTokenByOwnerdAppID/" + address + "/9";
	_get_request(geoUrl)
	
func _get_request(uri):

	var error = http_request.request(uri)

	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_request_completed( result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	if response.has("status"):
		is_mistake = not response.status
		if not is_mistake:
			var wallets = response.data.wallets
			for wallet in wallets:
				if wallet.secretType == "VECHAIN" and wallet.walletType == "WHITE_LABEL":
					_get_geokey(wallet.address)
	else:
		has_key = false
		for nft in response.data:
			var ndata = parse_json(nft.ipfs_data_json)
			if ndata.Title == "GeoKey":
				has_key = true
				SceneChanger.change_scene(global.data.scene, global.data.location, "", 1)

		checked_key = true
#	print(response)
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).

