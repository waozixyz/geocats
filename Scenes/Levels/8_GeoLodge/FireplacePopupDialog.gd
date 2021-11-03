extends InteractSimple

onready var see_pumpkin_code = get_tree().get_current_scene().get_node("CanvasLayer/PumpkinCodeHint")
onready var label = get_parent().get_node("PumpkinCode/ColorRect/Label")

func show_code():
	see_pumpkin_code.visible = true

func _ready():
	._ready()

	label.text = str(global.pumpkin_code)

func _on_body_exited(body):
	if body.name == "Player":
		see_pumpkin_code.visible = false

func _process(delta):
	._process(delta)
	if do_something:
		do_something = false
		show_code()
