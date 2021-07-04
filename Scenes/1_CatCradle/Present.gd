extends Area2D

onready var letter = get_node("../../Letter/Content")

func _ready():
	set_process_input(true)

func toggle(boolean):
	if boolean:
		return false
	else:
		return true

func _input(event):
	if Input.is_action_just_pressed("interact"):
		if  get_parent().visible || letter.visible:
			letter.visible = toggle(letter.visible)

		get_parent().visible = false
		print("hi")
