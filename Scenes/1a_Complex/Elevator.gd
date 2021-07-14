extends Area2D

onready var button = $Button

onready var player =  get_tree().get_current_scene().get_node("Player")

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
	if (Input.is_action_just_pressed("interact") || Input.is_action_just_pressed("jump")) && button.visible == true:
		button.visible = false
		if get_parent().name == "UpElevator":
			player.position.x = 2400
			player.position.y = 1600
		if get_parent().name == "DownElevator":
			player.position.x = 1100
			player.position.y = 300
		if get_parent().name == "HomeDoor":
			SceneChanger.change_scene("res://Scenes/1_CatCradle/1_CatCradle.tscn")
