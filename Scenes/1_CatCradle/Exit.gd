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
		MasterAudio.stream = load("res://Assets/Sfx/Wood_Door_Latch_Open_1.mp3")
		MasterAudio.play()
		SceneChanger.change_scene("res://Scenes/2_Complex/2_Complex.tscn")
		button.visible = false

