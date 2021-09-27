extends Area2D

onready var sprite = $Sprite
export var dmg = 4
var dead
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Ceiling":
		body.damage(dmg)
		dead = true

func _on_body_exited(body):
	pass
