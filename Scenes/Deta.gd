extends Node

var api_url

var show_login
var current_path
var last_path
var current_body
var last_body


var current_id = 0
var requests = {}

func _ready():
	if Global.DEBUG:
		api_url = "https://geodump.deta.dev"
	else:
		api_url = "https://geoapi.deta.dev"
	pause_mode = PAUSE_MODE_PROCESS

func claim_nft(nft_id):
	return add_request("/claim-nft", { "nft_id": nft_id })

func add_request(path, body = null, jwt = Global.data.access_token):
	current_id += 1
	requests[current_id] = {"status": "added", "path": path, "body": body, "jwt": jwt}
	return current_id

func check_request(id):
	if requests.size() > 0:
		for key in requests:
			var request = requests[key]
			if key == id and request.status == "done":
				request.status = "delivered"
				return request.response
	return false
	
var logged_in
func _process(delta):
	for key in requests:
		var request = requests[key]
		if request.status == "added":
			request.status = "requested"
			request.request = _get_request(key, request.path, request.body, request.jwt)
		elif request.status == "has_response":
			var response = request.response
			var response_code = request.res_code
			if response_code == 500 or response_code == 405 or response_code == 401:
				Global.data.login_msg = response_code
				SceneChanger.change_scene("TitleScreen")
				request.status = "need_login"
				logged_in = false
			elif response_code == 422:
				# signature has expired
				refresh_token()
				request.status = "need_refresh"
			elif response_code == 200:
				if response:
					if response.has("jwt"):
						Global.data.access_token = response["jwt"]
					if response.has("jwt_refresh"):
						Global.data.refresh_token = response["jwt_refresh"]
					if response.has("user"):
						Global.user = response["user"]
				request.status = "done"
			else:
				requests.erase(key)
				printerr(str(response_code) + ": " + str(response))
		elif request.status == "delivered":
			requests.erase(key)

func refresh_token():
	_get_request("/refresh", null, Global.data.renew_token)

func _get_request(id, path, body = null, jwt = Global.data.access_token):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed", [id])
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
		print(body, headers, uri)
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
var response_code
var refreshing
func _on_request_completed(_result, res_code, _headers, body, id):
	for key in requests:
		var request = requests[key]
		if key == id:
			request.response = parse_json(body.get_string_from_utf8())
			request.res_code = res_code
			print(request.response)
			request["status"] = "has_response"

