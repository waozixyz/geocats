extends Control

onready var play_button = $PlayButton
onready var exit_button = $ExitButton

onready var email = $Email
onready var password = $Password
onready var mistake = $Mistake
onready var nokey = $NoKey
onready var noserver = $NoServer
onready var connecting = $Connecting

var http_request

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	play_button.connect("pressed", self, "_login_pressed")
	http_request.connect("request_completed", self, "_on_request_completed")

	exit_button.connect("pressed", self, "_exit_pressed")

func _exit_pressed():
	visible = false

func _input(event):
	if event.is_action_pressed("enter"):
		_login_pressed()
	
	if event.is_action_pressed("escape") and get_parent().name == "TitleScreen":
		get_tree().quit()
	
func _login_pressed():
	var body = { "Email": email.text, "Password": password.text}
	var uri = global.url + "/login"
	connecting.visible = true
	nokey.visible = false
	mistake.visible = false
	noserver.visible = false
	_login_request(uri, body)
func _process(_delta):
	var res = global.response
	if res and res.has('process'):
		if res['process'] == "location":
			if res.has('scene') and res.has('location'):
				SceneChanger.change_scene(res.scene, res.location)

func _next():
	if get_parent().name == "TitleScreen":
		global.user_api('/get-location')
	else:
		visible = false

func _login_request(uri, body):

	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	var error = http_request.request(uri, headers, true, HTTPClient.METHOD_POST, query)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
func _on_request_completed( result, response_code, headers, body):
	connecting.visible = false
	var response = parse_json(body.get_string_from_utf8())

	if not response:
		noserver.visible = true
	else:
		noserver.visible = false
		if response.has('status') and response.status:
			if response.has("jwt"):
				global.data.jwt = response.jwt
			if response.has("vechain"):
				global.data.vechain = response.vechain
			if response.has("canLogin"):
				if response["canLogin"]:
					_next()
				else:
					nokey.visible = true
					
		else:
			mistake.visible = true
