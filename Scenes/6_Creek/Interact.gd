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
		if name == "CaveToDown":
			player.position.x = 4420
			player.position.y = 4950
		elif name == "CaveToUp":
			player.position.x = 4350
			player.position.y = 3250
		elif name == "JokeRoom":
			SceneChanger.change_scene("JokeRoom", 0, "", 1)
		elif name == "CavityPuzzleRoom":
			SceneChanger.change_scene("CavityPuzzleRoom", 0, "", 1)
		elif name == "GeoCacheRoom":
			SceneChanger.change_scene("GeoCacheRoom", 0, "", 1)
		elif name == "ExitJokeRoom":
			SceneChanger.change_scene("Creek", 2, "", 1)
		elif name == "ExitPuzzleRoom":
			SceneChanger.change_scene("Creek", 1, "", 1)
		elif name == "ExitGeoCache":
			SceneChanger.change_scene("Creek", 3, "", 1)
		elif name == "ToMountain":
			SceneChanger.change_scene("Mountain", 0, "", 1)

