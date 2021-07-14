extends KinematicBody2D

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var sprite = $ViewportContainer/Viewport/AnimatedSprite

var anim = "idle"
var velocity = Vector2()
var elapsed : int

var direction = 1

func _physics_process(delta):
	velocity.y += delta * gravity

	elapsed +=  OS.get_ticks_msec() * 0.001
	if elapsed > 100:
		velocity.x = 200 * direction
		if elapsed > 220:
			elapsed = 0

	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
	rotation()
	if is_on_wall():
		direction *= -1
	sprite.flip_h = direction - 1
	
	if velocity.x == 0:
		anim = "idle"
	else:
		anim = "walk"
	sprite.play(anim)
	sprite.animation = anim

var prev_rot: int = rotation_degrees
func rotation():
	var rot = rotation_degrees
	if is_on_floor():
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var normal = collision.normal
			if normal.x > -.6 && normal.x < .6:
				var slope_angle = rad2deg(normal.dot(Vector2(0,-1))) - 57
				var mul = 1
				if normal.x < 0:
					mul = -1
				rot = (rot + -slope_angle * 4 * mul) * .5
				rot = (rot + prev_rot) * .5
	else:
		if rot > 1:
			rot -= 1
		if rot < -1:
			rot += 1
	prev_rot = rot
	rotation_degrees = rot
