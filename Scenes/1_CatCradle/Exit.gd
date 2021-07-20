extends Area2D

onready var button = $Button

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
	if Input.is_action_just_pressed("ui_down") && button.visible == true:
		SceneChanger.change_scene("Complex", 0, "WoodDoorLatchOpen1", 1)
		button.visible = false

