extends Area2D

onready var sprite = $AnimatedSprite
export var dmg = 7

var touching
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

var body
func _on_body_entered(b):
	if b.name == "Ceiling":
		touching = true
		body = b

var elapsed = 0
func _process(delta):
	if touching and body and visible and body.hp > 0 and sprite.frame > 4 and sprite.frame < 27:
		elapsed += 1
		if elapsed % 13 == 0:
			body.damage(dmg * delta * global.fps)

func _on_body_exited(body):
	pass
