extends Control

onready var play_button = $PlayButton

onready var email = $Email
onready var password = $Password
onready var mistake = $Mistake
onready var nokey = $NoKey
onready var noserver = $NoServer

var http_request
var is_mistake = false

var key_name = "GeoKey"

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
	var uri = global.url + "/user"

	_login_request(uri, body)

func _next():
	SceneChanger.change_scene(global.data.scene, global.data.location, "", 1)
var waiting = false
func _process(delta):
	mistake.visible = is_mistake

	if global.updating:
		waiting = true
	elif waiting:
		var val = global.nfts[key_name]
		if val > 0:
			nokey.visible = false
			_next()
		else:
			nokey.visible = true
		waiting = false

func _login_request(uri, body):
	nokey.visible = false
	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	var error = http_request.request(uri, headers, true, HTTPClient.METHOD_POST, query)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
func _on_request_completed( result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if not response:
		noserver.visible = true
	else:
		noserver.visible = false
		if response.status:
			is_mistake = false
			if response.jwt:
				global.jwt = response.jwt
			if response.vechain:
				global.vechain = response.vechain
			global.check_nft(key_name)

		else:
			is_mistake = true
