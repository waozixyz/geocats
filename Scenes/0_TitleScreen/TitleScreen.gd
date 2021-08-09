extends Control

onready var play_button = $PlayButton

onready var email = $Email
onready var password = $Password
onready var mistake = $Mistake
onready var nokey = $NoKey

var http_request

var is_mistake = false

var checked_key = false
var has_key = false

var wallet_address = ""

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
	var uri = "https://api.geocats.net/user"
	_get_request(uri, body)

func _process(delta):
	mistake.visible = is_mistake
	if checked_key and not has_key:
		nokey.visible = true
	else:
		nokey.visible = false
		
func _get_geokey():
	var uri = "https://api.geocats.net/geokey"
	var body = { "Wallet": wallet_address }
	_get_request(uri, body)

func _get_request(uri, body):
	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	var error = http_request.request(uri, headers, false, HTTPClient.METHOD_POST, query)

	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_request_completed( result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	if response:
		is_mistake = false
		if response.has("status"):
			is_mistake = not response.status
			if not is_mistake:
				var wallets = response.data.wallets
				for wallet in wallets:
					if wallet.secretType == "VECHAIN" and wallet.walletType == "WHITE_LABEL":
						wallet_address = wallet.address
						_get_geokey()
		else:
			has_key = false
			for nft in response.data:
				var ndata = parse_json(nft.ipfs_data_json)
				if ndata.Title == "GeoKey":
					has_key = true
					SceneChanger.change_scene(global.data.scene, global.data.location, "", 1)

			checked_key = true
	else:
		is_mistake = true
#	print(response)
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).

