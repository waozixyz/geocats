extends Control

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var device = $Device
onready var label = $Label

func _ready():
	var first_child = device.get_node("CatCradle")
	_unselect_others(device)
	if first_child.disabled == false:
		first_child.selected = false
			
func _action(child):
	SceneChanger.change_scene(child.name, 0, "", 1)
	visible = false

func _get_label_name(cm):
	if cm == "CatCradle": 
		return "\"Cat's Cradel\""
	elif cm == "Complex":
		return "\"NONACO Housing Project #420\""
	elif cm == "GeoCity":
		return "\"GeoCity\""
	elif cm == "Creek":
		return "\"Canopy Creek\""
	elif cm == "LitterBox":
		return "\"The Great Litterbox\""
	elif cm == "Lodge":
		return "\"GeoLodge\""
# Called when the node enters the scene tree for the first time.
func _update_ui():
	var unlocked = global.data.nav_unlocked
	var nv = global.data.nav_visible
	for child in device.get_children():

		var unlock = child.get_node("Unlock")
		var lock = child.get_node("Lock")
		var map = child.get_node("Map")

		var rect = child.get_node("ColorRect")
		var cat = child.get_node("Cat")
		map.visible = false

		unlock.visible = false
		lock.visible = true
		child.disabled = true
		for key in unlocked:
			if key == child.name:
				unlock.visible = true
				lock.visible = false
				child.disabled = false
		for key in nv:
			if key == child.name:
				unlock.visible = false
				map.visible = true

		if child.pressed and unlock.visible:
			nv[child.name] = true
			child.pressed = false
		if child.hovered and (map.visible or unlock.visible) and not child.disabled:
			_unselect_others(device)
			child.selected = true

		if child.pressed and not child.disabled:
			_action(child)

		if child.selected:
			cat.visible = true
			rect.visible = true
			label.text = _get_label_name(child.name)
		else:
			cat.visible = false
			rect.visible = false
	global.data.nav_visible = nv

var last_visible = false
func _process(_delta):
	if last_visible != visible:
		if visible:
			if player:
				player.disable()
			_update_ui()

		else:
			if player:
				player.enable()
		last_visible = visible

func _input(event):
	if visible:
		input(device, event)

	_update_ui()
	if event.is_action_pressed("escape"):
		visible = false
