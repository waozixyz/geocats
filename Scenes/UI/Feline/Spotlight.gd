extends TextureButton

onready var popup_menu = $PopupMenu
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if pressed:
		popup_menu.rect_position = rect_position + get_local_mouse_position()
		popup_menu.popup()
