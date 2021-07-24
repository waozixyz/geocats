extends Node


const FILE_NAME = "user://game-data.json"

	
var file_data = {
	"scene": "CatCradle",
	"location": 0,
	"present": true,
	"progress": {},
}

func _ready():
	data.loadit()
	if file_data.progress:
		PROGRESS.variables = file_data.progress # load dialogue system data
	#SceneChanger.change_scene(file_data.scene, file_data.location, "", 1)

func saveit():
	file_data.progress = PROGRESS.variables
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(file_data))
	file.close()

func loadit():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			file_data = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
