extends Control

onready var splash = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	splash.frame = 0
	splash.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _proceed():
	SceneChanger.change_scene("TitleScreen", 0, "", 1)
	#get_tree().change_scene("res://Scenes/0_TitleScreen/TitleScreen.tscn")

func _process(delta):
	if splash.frame == 77:
		_proceed()

func _input(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		_proceed()
