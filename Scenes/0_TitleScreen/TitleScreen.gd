extends Control

onready var play_button = $PlayButton
func _ready():
	play_button.connect("pressed", self, "_start_game")

func _start_game():
	SceneChanger.change_scene("CatCradle", 0, "", 1)

