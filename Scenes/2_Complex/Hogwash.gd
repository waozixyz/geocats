extends Entity

var anim = "idle"

var start_time : int
var elapsed_time : int

var direction = 1
var jump_height = 100
var move_speed = 150
var idle = false
var f = 0.01

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	._ready()
	start_time = OS.get_ticks_msec() * f #start timer


var start_jump_time = 20
var end_jump_time = 30
	
func _physics_process(delta):
	if not idle:
		elapsed_time = OS.get_ticks_msec() * f - start_time

		if elapsed_time > 10:
			velocity.x = move_speed * direction
			if elapsed_time > start_jump_time and elapsed_time < end_jump_time:
				if is_on_floor():
					jump(jump_height)
			if elapsed_time > 40:
				start_time = OS.get_ticks_msec() * f #start timer
				velocity.x = 0
				start_jump_time = 10 + randi() % end_jump_time
				end_jump_time = start_jump_time + randi() % 10 
				if (randi() % 50 > 25):
					direction *= -1

		if velocity.x == 0:
			anim = "idle"
		else:
			anim = "walk"
	else:
		anim = "idle"
		velocity.x = 0
		
	if is_on_wall():
		direction *= -1
		velocity.x = 0

	sprite.flip_h = direction - 1		

	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
	sprite.play(anim)
	sprite.animation = anim

