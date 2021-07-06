extends Area2D

onready var letter = get_node("../../Letter/Content")

var touching = false

func _ready():
	set_process_input(true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body):
	if body.name == "Player":
		touching = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
	
func toggle(boolean):
	if boolean:
		return false
	else:
		return true

func _input(event):
	if Input.is_action_just_pressed("interact") && touching:
		if  get_parent().visible || letter.visible:
			letter.visible = toggle(letter.visible)

		get_parent().visible = false

