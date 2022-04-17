extends Control

onready var label = $RichTextLabel

var dir_path = "res://Assets/Levels/XAPS/DesertOutpost/geopedia"
var file = File.new()

func _ready():
	for child in get_children():
		if child is TextureButton:
			child.connect("pressed", self, "_btn_pressed", [child])


		#child.mouseif get_parent().module.a > 0
func _update_label(file_name):
	label.text = "" 
	var path = dir_path + "/" + file_name + ".txt"
	if file.file_exists(path):
		file.open(path, File.READ)
		while not file.eof_reached(): # iterate through all lines until the end of file is reached
			var line = file.get_line()
			label.text += line
			label.newline()
		file.close()
	
func _btn_pressed(btn):
	_update_label(btn.name.to_lower())

