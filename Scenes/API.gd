extends Node

var api_url

var show_login
var current_path
var last_path
var current_body
var last_body

func _ready():
	if Global.debug:
		api_url = "https://geodump.deta.dev"
	else:
		api_url = "https://geoapi.deta.dev"
	pause_mode = PAUSE_MODE_PROCESS

func refresh_token():
	get_request("/refresh", null, Global.data.refresh_token)
func get_request(path, body = null, jwt = Global.data.access_token):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	current_path = path
	current_body = body
	# complete the url to use
	var uri = api_url + path

	# headers
	var headers = PoolStringArray()	
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	# jwt access token
	if jwt:
		headers.append("Authorization: Bearer " + jwt)
	
	# do the request
	var error
	if body:
		# Convert data to json string:
		var query = JSON.print(body)
		error = http_request.request(uri, headers, false, HTTPClient.METHOD_POST, query)
	else:
		error = http_request.request(uri, headers, false)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	return http_request

func _save_request():
	last_body = current_body
	last_path = current_path
	
var response
var ready_to_repeat
func _on_request_completed(_result, response_code, _headers, body):
	ready_to_repeat = false
	response = parse_json(body.get_string_from_utf8())
	if response_code == 500:
		Global.data.login_msg = 500
		SceneChanger.change_scene("TitleScreen")
	if response_code == 422:
		# signature has expired
		refresh_token()
	elif response_code == 405:
		# method not allowed
		Global.data.login_msg = 405
		SceneChanger.change_scene("TitleScreen")
	elif response_code == 200:
		if response:
			if response.has("jwt"):
				Global.data.access_token = response["jwt"]
				ready_to_repeat = true
			if response.has("jwt_refresh"):
				Global.data.refresh_token = response["jwt_refresh"]
			if response.has("user"):
				Global.user = response["user"]
			
	print(response, response_code)
