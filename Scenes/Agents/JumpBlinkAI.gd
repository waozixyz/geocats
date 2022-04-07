extends MovingBody

var ticks = 0
var idle

var next_jump_height = 0
func _init():
	._init()

func _physics_process(_delta):
	if idle:
		apply_gravity()
	elif is_on_floor():
		jump(jump_height)
		next_jump_height = 0
	
	ticks += 1 
		
	if int(ticks* .1) % 40 == 0:
		anim = "blink"
	else:
		anim = "idle"

	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
	sprite.play(anim)
	sprite.animation = anim
				
