extends Control

onready var base = $Base
onready var eyes = $Base/Eyes
onready var icons = $Base/Icons

# feline map
onready var feline_map = get_tree().get_current_scene().get_node("Default/CanvasLayer/FelineMap")

## buttons
onready var bt_exit = icons.get_node("Exit")
onready var bt_map = icons.get_node("Map")
onready var bt_location = icons.get_node("Location")
onready var bt_return = icons.get_node("Return")

var active : bool = false

func _ready():
	pass

func check(button, action):
	var rect = button.get_node("ColorRect")
	var area = button.get_node("Area2D")
	if area.pressed:
		area.pressed = false
		if action == "exit":
			active = false
		if action == "map":
			feline_map.visible = true
			active = false
			
	if area.hovered:
		rect.visible = true
	else:
		rect.visible = false

var ticks = 0
func _process(delta):
	if active:
		if ticks < 10 :
			eyes.frame = 2
		if ticks == 10:
			eyes.frame = 1
		## make icons visible
		if ticks > 15:
			eyes.visible = false
			icons.visible = true
			
			# exit button
			check(bt_exit, "exit")
			check(bt_map, "map")
			check(bt_location, "location")
			check(bt_return, "menu")

		else:
			icons.visible = false
			eyes.visible = true

		if ticks < 30:
			ticks += .5
		base.visible = true
	else:
		# start shutdown and hide feline
		base.visible = false
		if ticks > 0:
			if ticks == 14:
				ticks = 5
			ticks -= .5
	
func _input(event):
	if event.is_action_pressed("escape"):
		if active:
			active = false
		else:
			active = true
