extends Node


const FILE_NAME = "user://game-data.json"


func _correct_data(dat):
	var out = global.data
	for key in dat:
		out[key] = dat[key]

	return out


func _ready():
	#loadit()

	# load dialogue system data
	PROGRESS.variables = global.data.prog_var
	PROGRESS.dialogues = global.data.prog_dia

func saveit():
	global.data.prog_var = PROGRESS.variables
	global.data.prog_dia = PROGRESS.dialogues
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(global.data))
	file.close()
	
func _load_audio_bus(bus_name):
	var i = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(i, global.data["no" + bus_name.to_lower()])
	AudioServer.set_bus_volume_db(i, global.data[bus_name.to_lower()])

	
func loadit():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			global.data = _correct_data(data)
			_load_audio_bus("Music")
			_load_audio_bus("Sound")
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
