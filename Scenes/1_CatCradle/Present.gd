extends Area2D

onready var letter = get_node("../../CanvasLayer/Letter")
onready var interact_with = get_node("../../CanvasLayer/InteractWith")
var touching = false

func _ready():
	set_process_input(true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body):
	if body.name == "Player":
		touching = true
		if  get_parent().visible:
			interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false
	
func toggle(boolean):
	if boolean:
		return false
	else:
		return true

func _input(event):
	if Input.is_action_just_pressed("interact") && touching:
		if  get_parent().visible || letter.visible:
			letter.visible = toggle(letter.visible)
			if letter.visible == false and get_parent().visible == false:
				interact_with.visible = false

		get_parent().visible = false

