extends StaticBody2D

onready var boulder = get_parent().get_node("Boulder")
onready var sprite = $AnimatedSprite
onready var particles = $Particles
var hp = 100

func damage(dmg):
	hp -= dmg
	sprite.modulate = Color(2, 0, 0)

func _ready():
	particles.visible = false

var shot_particles
func _process(delta):
	var color = sprite.modulate
	if color.r > 1:
		color.r -= .1
	if color.g < 1:
		color.g += .1
	if color.b <1:
		color.b += .1
	sprite.modulate = color
	var total = sprite.get_sprite_frames().get_frame_count("default")

	if hp <= 0:
		if not shot_particles:
			particles.visible = true
			for particle in particles.get_children():
				var target = Vector2(rand_range(-50, 50), 100)
				var tween = Tween.new()
				get_parent().add_child(tween)
				tween.interpolate_property(particle, "position", particle.position, target, 2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
				tween.interpolate_property(particle, "modulate:a", particle.modulate.a, 0, 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
				tween.start()
			shot_particles = true
	else:
		var frame = 5 - (hp * 0.01 * total) / total * total
		sprite.frame = floor(frame)
	if particles.get_node("0").modulate.a <= 0:
		remove_child(self)
