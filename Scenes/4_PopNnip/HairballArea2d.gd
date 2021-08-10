extends Area2D

onready var interact_with = get_tree().get_current_scene().get_node("CanvasLayer/InteractWith")
var touching = false

func _ready():
	set_process_input(true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		if touching:
			AudioStreamManager.play("res://Assets/Sfx/SFX/ElectroCat2.ogg")
			interact_with.visible = false
