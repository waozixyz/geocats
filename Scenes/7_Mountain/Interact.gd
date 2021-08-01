extends Area2D

onready var button = $Button
onready var sound = $Sound
onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var chat_with =  get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		button.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		button.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_down") && button.visible == true && not chat_with.started:
		if name == "GoDown":
			player.position.x = 1900
			player.position.y = 4900
		elif name == "GoUp":
			player.position.x = 1900
			player.position.y = 3000


