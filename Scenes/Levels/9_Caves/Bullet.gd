extends Area2D

onready var sprite = $Sprite
var dmg = 4

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Ceiling":
		body.hp -= dmg * 7

func _on_body_exited(body):
	pass
