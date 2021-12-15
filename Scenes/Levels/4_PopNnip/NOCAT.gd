extends Entity

var anim = "idle"

func _ready():
	sprite = $AnimatedSprite
	jump_height = 30
	._ready()

var ticks = 0
var jump_tick = 100
var walk_tick = 10
var direction = 1
var idle = false
func _physics_process(delta):
	if not idle:
		ticks += 1
		
		if ticks % jump_tick == 0:
			jump(jump_height)
			jump_tick = int(rand_range(200, 400))
		if (ticks / 10) % walk_tick == 0:
			velocity.x = 100 * direction
			walk_tick = int(rand_range(8, 20))
		if ticks % 200 == 0:
			direction *= -1
			velocity.x = 0
		if velocity.x == 0:
			anim = "idle"
		else:
			anim = "walk"
	else:
		velocity.x = 0
		
	sprite.flip_h = direction - 1		
	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
	sprite.play(anim)
	sprite.animation = anim
