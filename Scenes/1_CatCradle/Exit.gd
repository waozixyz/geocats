extends Area2D


func _ready():
	connect("body_entered", self, "_on_body_enter")

func _on_body_enter(value):
	if value.name == "Player":
		SceneChanger.change_scene("res://Scenes/1a_Complex/1a_Complex.tscn", "fade")
		
