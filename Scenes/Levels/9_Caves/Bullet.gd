extends Area2D

onready var sprite = $Sprite
export var dmg = 20
var tween = Tween.new()
var mode
var speed = 4
var dead
var deg = 1
var dest_deg
var max_life = 2000
var life_timer = 0
onready var sound = $Sound

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	dest_deg = rand_range(0, 360)
	deg = rand_range(dest_deg - 360, dest_deg)
	if visible:
		sound.play()
func _on_body_entered(body):
	if body.has_method("damage") and visible:
		body.damage(dmg)
		dead = true

func _on_body_exited(body):
	pass

func _process(delta):
	life_timer += 1 * delta * Global.fps
	if life_timer >= max_life:
		dead = true
	rotation_degrees = deg
	if mode == "spiral":
		if deg < dest_deg:
			deg += .5 * speed
		position.x += speed * cos(deg2rad(deg))
		position.y += speed * sin(deg2rad(deg))



