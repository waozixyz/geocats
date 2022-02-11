extends MovingBody


onready var chat = $Area2D

func _ready():
	no_rotate = true
	._ready()
	init = false
	jump_height = 15

var anim = "idle"
var f = 0.002
var elapsed = 0
var ticks = 0
var margin = 50
var mov_speed = 350

var init = false
var lastDiff = 0
var diff = 0
var climbing = false

var add_x = 0
var add_y = 0

var next_jump_height = 0


func _physics_process(delta):
	var dfps = delta * global.fps
	var scene_name = get_tree().get_current_scene().name
	print(position, visible)
	var follow = PROGRESS.variables.get("affogato_follow")
	chat.disabled = true if follow else false
	velocity.x = 0
	velocity.y = 0

	if visible:
		ticks += 1 
		if int(ticks* .1) % 40 == 0 and velocity.x == 0:
			anim = "blink"
		else:
			anim = "idle"

		if is_on_floor():
			jump(jump_height)
			next_jump_height = 0

		if not climbing:
			velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
		sprite.play(anim)
		sprite.animation = anim
			
