extends RichTextLabel

onready var file = 'res://Assets/Levels/10_DesertOutpost/survival_guide/weather.txt'
onready var f = File.new()
func _on_Button_toggled(button_pressed):
	if button_pressed==true:
		if f.file_exists(file):
			f.open(file, File.READ)
			while not f.eof_reached(): # iterate through all lines until the end of file is reached
				var line = f.get_line()
				text += line
				newline()
			f.close()
	elif button_pressed==false:
		pass

