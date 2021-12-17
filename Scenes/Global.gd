extends Node

const debug = true
const fps = 60
var player_position
var player_direction
var crt_noise = 0.0
var pause_msg = ""

var user = {
	"visited": [],
}

var data =  {
	"access_token": "",
	"renew_token": "",
	"sound": -6,
	"music": -6,
	"nosound": false,
	"nomusic": false,
	"player_hp": 100,
	"nav_unlocked": [],
	"login_msg": 200,
	"season": "",
}

var pumpkin_code = ""


func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		#API.get_request("/update-user")
		saveit()
		get_tree().quit()


func _ready():
	randomize()
	for _i in range(0, 7):
		pumpkin_code += str(int(rand_range(1, 8)))
	loadit()

	# load dialogue system data
	#PROGRESS.variables = Global.data.prog_var
	#PROGRESS.dialogues = Global.data.prog_dia



const FILE_NAME = "user://game-data.json"

func _correct_data(dat):
	var out = data
	for key in dat:
		out[key] = dat[key]

	return out
func saveit():
	#Global.data.prog_var = PROGRESS.variables
	#Global.data.prog_dia = PROGRESS.dialogues
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	
func _load_audio_bus(bus_name):
	var i = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(i, data["no" + bus_name.to_lower()])
	AudioServer.set_bus_volume_db(i, data[bus_name.to_lower()])

	
func loadit():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var file_data = parse_json(file.get_as_text())
		file.close()
		if typeof(file_data) == TYPE_DICTIONARY:
			data = _correct_data(file_data)
			_load_audio_bus("Music")
			_load_audio_bus("Sound")
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
