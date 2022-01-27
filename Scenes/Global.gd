extends Node

const EDITION = "Steam"
const DEBUG = true
const FPS = 60

const DATA_FILE = "user://data.json"
const USER_FILE = "user://user.json"

# player stuff
var user = {
	"visited": [],
	"location": 0,
	"direction": 0,
	"hp": 100,
}

var data =  {
	# api stuff
	"access_token": "",
	"renew_token": "",
	# sound stuff
	"sound": -6,
	"music": -6,
	"nosound": false,
	"nomusic": false,
	# feline stuff
	"nav_unlocked": [],
	"nav_visited": [],
	# dialogue variables
	"prog_var": {},
	"prog_dia": {},
}

var pumpkin_code = ""


func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
	
		data.prog_var = PROGRESS.variables
		data.prog_dia = PROGRESS.dialogues
		_save_data(data, DATA_FILE)
		_save_data(user, USER_FILE)
		get_tree().quit()


func _ready():
	randomize()
	for _i in range(0, 7):
		pumpkin_code += str(int(rand_range(1, 8)))
		
	# overwrite data with saved data
	data = _load_data(DATA_FILE)
	user = _load_data(USER_FILE)
	
	# load audio buses
	_load_audio_bus("Music")
	_load_audio_bus("Sound")

	# load dialogue system data
	PROGRESS.variables = data.prog_var
	PROGRESS.dialogues = data.prog_dia





func _correct_data(dat):
	var out = data
	for key in dat:
		out[key] = dat[key]

	return out

func _save_data(data, file_name):
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	
func _load_audio_bus(bus_name):
	var i = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(i, data["no" + bus_name.to_lower()])
	AudioServer.set_bus_volume_db(i, data[bus_name.to_lower()])

	
func _load_data(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		var file_data = parse_json(file.get_as_text())
		file.close()
		if typeof(file_data) == TYPE_DICTIONARY:
			return _correct_data(file_data)
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
