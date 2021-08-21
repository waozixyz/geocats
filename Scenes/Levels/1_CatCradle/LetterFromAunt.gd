extends RichTextLabel

onready var file = 'res://Assets/Levels/1_CatCradle/LetterFromAunt.txt'

func _ready():
	load_file()

	
func load_file():
	var f = File.new()
	if f.file_exists(file):
		f.open(file, File.READ)
		var index = 1
		while not f.eof_reached(): # iterate through all lines until the end of file is reached
			var line = f.get_line()
			text += line
			newline()
			index += 1
		f.close()
	return
