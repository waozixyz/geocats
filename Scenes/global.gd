extends Node

const edition = "Steam"
const debug = true
const fps = 60

const data_file = "user://demo_data.json"
const user_file = "user://demo_user.json"

var crt_noise = 0.0

# player stuff
var user = {
	"current_territory": "",
	"current_level": "",
	"visited": {},
	"location": 0,
	"position": Vector2(0,0),
	"direction": 0,
	"hp": 100,
	"following": [],
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
	# dialogue variables
	"prog_var": {},
	"prog_dia": {},
	"prog_quests": {},
}

var pumpkin_code = ""


func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		data.prog_var = PROGRESS.variables
		data.prog_dia = PROGRESS.dialogues
		data.prog_quests = PROGRESS.quests
		_save_data(data, data_file)
		_save_data(user, user_file)
		get_tree().quit()


func _ready():
	randomize()
	for _i in range(0, 7):
		pumpkin_code += str(int(rand_range(1, 8)))
		
	# overwrite data with saved data
	data = _load_data(data_file, data)

	#user = _load_data(user_file, user)

	# load audio buses
	_load_audio_bus("Music")
	_load_audio_bus("Sound")

	# load dialogue system data
	PROGRESS.variables = data.prog_var
	PROGRESS.dialogues = data.prog_dia
	PROGRESS.quests = data.prog_quests

func _correct_data(dat, default_data):
	var out = default_data
	for key in dat:
		out[key] = dat[key]

	return out

func _save_data(dat, file_name):
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(to_json(dat))
	file.close()
	
func _load_audio_bus(bus_name):
	var i = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(i, data["no" + bus_name.to_lower()])
	AudioServer.set_bus_volume_db(i, data[bus_name.to_lower()])

func _load_data(file_name, default_data):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		var file_data = parse_json(file.get_as_text())
		file.close()
		if typeof(file_data) == TYPE_DICTIONARY:
			return _correct_data(file_data, default_data)
		else:
			printerr("Corrupted data!")
			return default_data

	else:
		printerr("No saved data!")
		return default_data

