extends Control

onready var device = $Device

func _ready():
	var first_child = device.get_node("CatCradle")
	first_child.selected = true
	_unselect_others(first_child.name)

func _unselect_others(keep):
	for child in device.get_children():
		if child.name != keep:
			child.selected = false
# Called when the node enters the scene tree for the first time.
func _update_ui():
	var unlocked = global.data.nav_unlocked
	var nv = global.data.nav_visible
	for child in device.get_children():
		var unlock = child.get_node("Unlock")
		var lock = child.get_node("Lock")
		var map = child.get_node("Map")
		var label = child.get_node("Label")
		var rect = child.get_node("ColorRect")
		var cat = child.get_node("Cat")
		map.visible = false
		label.visible = false
		unlock.visible = false
		lock.visible = true
		for key in unlocked:
			if key == child.name:
				unlock.visible = true
				lock.visible = false
		if child.pressed and unlock.visible:
			nv[child.name] = true
			child.pressed = false
		for key in nv:
			if key == child.name:
				unlock.visible = false
				map.visible = true
				label.visible = true
		if child.hovered and (map.visible or unlock.visible):
			child.selected = true
			_unselect_others(child.name)


	
		if child.selected:
			cat.visible = true
			rect.visible = true
		else:
			cat.visible = false
			rect.visible = false
	global.data.nav_visible = nv

var last_visible = false
func _process(delta):
	if last_visible != visible:
		if visible:
			_update_ui()
		last_visible = visible
	
func _input(event):
	_update_ui()
	if event.is_action_pressed("escape"):
		visible = false
