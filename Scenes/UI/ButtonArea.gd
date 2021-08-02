extends Area2D

var pressed : bool = false

func _ready():
	connect("input_event", self, "_on_input_event")
	set_process_input(true)

		
func _on_input_event( viewport, event, shape_idx ):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pressed = true
