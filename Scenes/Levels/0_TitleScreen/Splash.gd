extends Control

onready var splash = $AnimatedSprite

func _proceed():
	SceneChanger.change_scene("TitleScreen", 0, "", 1)

func _process(delta):
	if splash.frame == 77:
		_proceed()

func _input(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		_proceed()
