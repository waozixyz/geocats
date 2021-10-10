extends Area2D

onready var sprite = $Sprite
export var dmg = 4
var tween = Tween.new()
var mode
var speed = 4
var dead
var deg = 1
var dest_deg

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	dest_deg = rand_range(0, 360)
	deg = rand_range(dest_deg - 360, dest_deg)

func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(dmg)
		dead = true

func _on_body_exited(body):
	pass

func _process(_delta):
	rotation_degrees = deg
	if mode == "spiral":
		if deg < dest_deg:
			deg += .5 * speed
		position.x += speed * cos(deg2rad(deg))
		position.y += speed * sin(deg2rad(deg))



