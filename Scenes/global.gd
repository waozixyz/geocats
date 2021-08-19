extends Node

var player_position
var player_direction
var crt_noise = 0.0

var data =  {
	"scene": "CatCradle",
	"location": 0,
	"present": true,
	"prog_var": {},
	"prog_dia": {},
	"player_hp": 100.0,
	"nav_visible": {},
	"nav_unlocked": {"CatCradle": true},
}

func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Data.saveit()
		get_tree().quit()

#var url = "https://api.geocats.net"
var url = "http://127.0.0.1:5000"
var http_request

var jwt : String = ""
var vechain: String = ""

var nfts = {}
var updating = false

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")

func check_nft(nft):
	updating = true
	var uri = url + "/nft"
	var body = { "NFT": nft }
	_get_request(uri, body)


func _get_request(uri, body):
	# Convert data to json string:
	var query = JSON.print(body)
	var headers = PoolStringArray()
	# Add 'Content-Type' header:
	headers.append("Content-Type: application/json")
	headers.append("Authorization: Bearer " + jwt)
	var error = http_request.request(uri, headers, true, HTTPClient.METHOD_POST, query)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_request_completed( result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if response.status == true:
		nfts[response.name] = response.val
	updating = false
