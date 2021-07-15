extends Area2D

onready var button = $Button
onready var sound = $Sound
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
	if Input.is_action_just_pressed("interact") && button.visible == true:
		button.visible = false

		if get_parent().name == "UpElevator":
			player.position.x = 2400
			player.position.y = 1600
		if get_parent().name == "DownElevator":
			player.position.x = 1100
			player.position.y = 300
		if get_parent().name == "HomeDoor":
			MasterAudio.stream = load("res://Assets/Sfx/Wood_Door_Latch_Open_1.mp3")
			MasterAudio.play()
			SceneChanger.change_scene("res://Scenes/1_CatCradle/1_CatCradle.tscn")
		if name == "Exit":
			SceneChanger.change_scene("res://Scenes/2_GeoCity/2_GeoCity.tscn")
		if get_parent().name == "Hogwash":
			print("yes")
		if get_parent().name == "Cleopartis":
			print("hii")
