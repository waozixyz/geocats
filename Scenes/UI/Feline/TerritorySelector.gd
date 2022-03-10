extends Control

onready var spotlight = $SpotLight
onready var geocity = $GeoCity
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var territories = []

# Called when the node enters the scene tree for the first time.
func _ready():
	territories = [geocity]
	pass # Replace with function body.


	
func _input(event):
	for territory in territories:
		if territory.pressed:
			var mouse_pos = territory.rect_position + territory.get_local_mouse_position()
			spotlight.position = mouse_pos
			var popup_menu = territory.get_node("PopupMenu")
			popup_menu.rect_position = mouse_pos
			popup_menu.popup()
