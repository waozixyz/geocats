extends Area2D

onready var button = $Button
onready var sound = $Sound
onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")
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
		if name == "UpElevator":
			player.position.x = 1600
			player.position.y = 1000
			affogato.position = player.position

		elif name == "DownElevator":
			player.position.x = 710
			player.position.y = 180
			affogato.position = player.position
		elif name == "HomeDoor":
			SceneChanger.change_scene("CatCradle", 1, "WoodDoorLatchOpen1", 1)
		elif name == "Exit":
			SceneChanger.change_scene("GeoCity", 0, "FootstepsOnGravelFast", 1.5)

