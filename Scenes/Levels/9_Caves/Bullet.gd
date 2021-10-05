extends Area2D

onready var sprite = $Sprite
export var dmg = 4
var tween = Tween.new()
var mode 
var dead
var deg = 1

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Ceiling":
		body.damage(dmg)
		dead = true

func _on_body_exited(body):
	pass

func _process(_delta):
	if mode == "spiral":
		deg += .5
		position.x += 2 * cos(deg2rad(deg))
		position.y += 2 * sin(deg2rad(deg))
	if deg > 360:
		deg = 0

		

