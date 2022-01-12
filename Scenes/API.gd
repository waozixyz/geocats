extends Node

var api_url

var show_login
var current_path
var last_path
var current_body
var last_body


var current_id = 0
var requests = []
var current_request_id = 0

func _ready():
	if Global.debug:
		api_url = "https://geodump.deta.dev"
	else:
		api_url = "https://geoapi.deta.dev"
	pause_mode = PAUSE_MODE_PROCESS

func is_nft_available_db(nft_id):
	return add_request("/available-nft-db", { "nft_id": nft_id })

func add_request(path, body = null, jwt = Global.data.access_token):
	current_id += 1
	requests.append({"id": current_id, "path": path, "body": body, "jwt": jwt})
	return current_id

var current_request
var current_response
func _process(delta):
	if requests.size() > 0 and requests[0].id != current_request_id:
		var request = requests[0]
		current_request_id = request.id
		current_request = get_request(request.path, request.body, request.jwt)
		
	if not refreshing and current_request:
		var data_size = current_request.get_downloaded_bytes()
		if data_size > 0 and response and current_request.get_http_client_status() == 0:
			current_response = response
			current_request = null
			requests.pop_front()
	
func refresh_token():
	get_request("/refresh", null, Global.data.renew_token)

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
var refreshing
func _on_request_completed(_result, response_code, _headers, body):
	response = parse_json(body.get_string_from_utf8())
	if response_code == 500:
		Global.data.login_msg = 500
		SceneChanger.change_scene("TitleScreen")
		refreshing = true
	elif response_code == 422:
		# signature has expired
		refresh_token()
		refreshing = true
	elif response_code == 405:
		# method not allowed
		Global.data.login_msg = 405
		SceneChanger.change_scene("TitleScreen")
		refreshing = true
	elif response_code == 200:
		if response:
			if response.has("jwt"):
				Global.data.access_token = response["jwt"]

			if response.has("jwt_refresh"):
				Global.data.refresh_token = response["jwt_refresh"]
			if response.has("user"):
				Global.user = response["user"]
		refreshing = false
	else:
		requests.pop_front()
		printerr(str(response_code) + ": " + str(response))
