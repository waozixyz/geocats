extends Control

onready var btn = $Button
onready var label = $Label

onready var back = $Back
onready var forth = $Forth

var texture_path = "res://Assets/UI/Feline/MapView/"
var current = 0
var list = ["CatsCradle", "Complex", "GeoCity", "Creek", "Litterbox", "GeoLodge"]

func _change_button():
	btn.texture_normal = load(texture_path + list[current] + '.png')
	btn.texture_hover = load(texture_path + list[current] + '_hovered.png')
	btn.texture_pressed = load(texture_path + list[current] + '_clicked.png')
	label.text = _get_label_name()

func _ready():
	_change_button()
	
func _get_label_name():
	var rtn = "\""
	match current:
		0: rtn += "Cat's Cradel"
		1: rtn += "NONACO Housing Project #420"
		2: rtn += "GeoCity"
		3: rtn += "Canopy Creek"
		4: rtn += "The Great Litterbox"
		5: rtn += "GeoLodge"
	rtn += "\""
	return rtn

func _input(event):
	if visible and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pass
			else:
				if back.pressed:
					current -= 1
					if current < 0:
						current = list.size() - 1
					_change_button()
				elif forth.pressed:
					current += 1
					if current > list.size() - 1:
						current = 0
					_change_button()
				if btn.pressed:
					print(list[current])
					SceneChanger.change_scene(list[current], 0, "WayoWayo")
