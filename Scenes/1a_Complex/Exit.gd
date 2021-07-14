extends Area2D


func _ready():
	connect("body_entered", self, "_on_body_enter")

func _on_body_enter(body):
	if body.name == "Player":
		SceneChanger.change_scene("res://Scenes/2_GeoCity/2_GeoCity.tscn")
		
