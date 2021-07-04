extends RichTextLabel

onready var file = 'res://Assets/LevelAssets/1_CatCradle/LetterFromAunt.txt'

func _ready():
	load_file(file)

	
func load_file(file):
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		text += line
		newline()
		index += 1
	f.close()
	return
