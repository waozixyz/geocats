extends Area2D

var pressed : bool = false
var hovered: bool = false
var selected: bool = false
var disabled: bool = false
func _ready():
	connect("input_event", self, "_on_input_event")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	set_process_input(true)

func _on_input_event( viewport, event, shape_idx ):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pressed = true

func _on_mouse_entered():
	hovered = true
			
func _on_mouse_exited():
	hovered = false
	
