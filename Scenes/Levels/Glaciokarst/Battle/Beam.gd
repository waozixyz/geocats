extends Area2D

onready var sprite = $AnimatedSprite
export var dmg = 7
onready var sound = $Sound
onready var explosion = $Explosion

var touching
func _ready():
	var err = connect("body_entered", self, "_on_body_entered")
	assert(err == OK)

	#sound.connect("finished", self, "_repeat")
	
func _repeat():
	if visible:
		sound.play()

var body
func _on_body_entered(b):
	if b.name == "Ceiling":
		touching = true
		body = b

var elapsed = 0
func _process(delta):
	if visible:
		if sprite.frame == 31:
			visible = false
		if sprite.frame > 4 and sprite.frame < 24 and not sound.is_playing():
			sound.play()
		# special ceilng logic
		if touching and body and body.hp > 0 and sprite.frame > 4 and sprite.frame < 27:
			elapsed += 1
			if elapsed % 13 == 0:
				body.damage(dmg * delta * global.fps)
			if not explosion.is_playing():
				explosion.play()

