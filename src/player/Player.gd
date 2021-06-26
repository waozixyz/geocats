extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 800

var vel = Vector2()

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var sprite = get_node("AnimatedSprite")

var anim = "idle"


func _physics_process(delta):

	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		vel.x = move_toward(vel.x, 0, STOP_FORCE * delta)
	else:
		vel.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	vel.x = clamp(vel.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	vel.y += gravity * delta

	# Move based on the vel and snap to the ground.
	vel = move_and_slide_with_snap(vel, Vector2.DOWN, Vector2.UP)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		vel.y = -JUMP_SPEED
	
	if abs(vel.x) < 10:
		vel.x = 0
	# set animation
	if vel.x == 0:
		anim = "idle"
	else:
		anim = "walk"
	if vel.x > 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)
	sprite.play(anim)
	sprite.animation = anim
