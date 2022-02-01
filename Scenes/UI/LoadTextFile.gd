extends RichTextLabel

export(String, FILE, "*.txt") var text_file

func _ready():
	var f = File.new()
	if f.file_exists(text_file):
		f.open(text_file, File.READ)
		while not f.eof_reached(): # iterate through all lines until the end of file is reached
			var line = f.get_line()
			text += line
			newline()

		f.close()
	return
