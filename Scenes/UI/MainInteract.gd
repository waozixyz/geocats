extends Area2D
class_name MainInteract

onready var button = $Button

onready var chat_with =  get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().get_node("Default/Player")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		button.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		button.visible = false

func _can_interact():
	if Input.is_action_just_pressed("ui_down") && button.visible == true && not chat_with.started && not player.disabled:
		return true
	else:
		return false
