extends Control

onready var btn = $Button
onready var label = $Label

onready var back = $Back
onready var forth = $Forth

var texture_path = "res://Assets/UI/Feline/MapView/"
var current = 0
var list = ["CatsCradle", "Complex", "GeoCity", "Creek", "Litterbox", "GeoLodge"]

func _change_button():
	var path = texture_path
	var nav_unlocked = global.data.nav_unlocked
	var nav_visible = global.data.nav_visible
	var is_unlocked = nav_unlocked.has(list[current])
	var is_visible = nav_visible.has(list[current])

	label.text = ""
	if is_visible:
		path += list[current]
		label.text = _get_label_name()
	elif is_unlocked:
		path += "unlocked"
	else:
		path += "locked"
	btn.texture_normal = load(path + '.png')
	btn.texture_hover = load(path + '_hovered.png')
	btn.texture_pressed = load(path + '_clicked.png')

func _press_button():
	var nav_unlocked = global.data.nav_unlocked
	var nav_visible = global.data.nav_visible
	var is_unlocked = nav_unlocked.has(list[current])
	var is_visible = nav_visible.has(list[current])
	if is_unlocked and not is_visible:
		nav_visible[list[current]] = true
		_change_button()
	if is_visible:
		SceneChanger.change_scene(list[current], 0, "WayoWayo")

func _ready():
	_change_button()
	var unlocked = global.data.nav_unlocked
	var nv = global.data.nav_visible

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
				if back.visible and back.pressed:
					current -= 1
					_change_button()
				elif forth.visible and forth.pressed:
					current += 1
					_change_button()
				if btn.pressed:
					_press_button()

				if current == 0:
					back.visible = false
				else:
					back.visible = true
				if current == list.size() -1:
					forth.visible = false
				else:
					forth.visible = true
