extends Control

onready var play_button = $PlayButton
func _ready():
	play_button.connect("pressed", self, "_start_game")

func _start_game():
	SceneChanger.change_scene("res://Scenes/1_CatCradle/1_CatCradle.tscn", 0, "", 1)

