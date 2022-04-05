extends MovingBody
class_name SimpleMovingAI, "res://Assets/UI/Debug/moving_npc_icon.png"



var direction = 1


export(int) var move_speed = 150
export(Array) var jump_delay_range = [100, 400]
export(Array) var walk_delay_range = [1, 20]
export(int) var change_direction = 200


var idle = false
var ticks = 0
var jump_tick
var walk_tick

func _get_jump_tick():
	return int(rand_range(jump_delay_range[0], jump_delay_range[1]))
func _get_walk_tick():
	return int(rand_range(walk_delay_range[0], walk_delay_range[1]))
	
func _ready():
	direction = int(sprite.flip_h) * -2 - 1

	._ready()
	jump_tick = _get_jump_tick()
	walk_tick = _get_walk_tick()

func _physics_process(_delta):
	if not idle:
		ticks += 1
		
		if ticks % jump_tick == 0:
			if is_on_floor() and anim == "walk":
				jump(jump_height)
			jump_tick = _get_jump_tick()
		if (ticks / 10) % walk_tick == 0:
			velocity.x = move_speed * direction
			walk_tick = _get_walk_tick()
		if change_direction > 0:
			if ticks % change_direction == 0:
				direction *= -1
				velocity.x = 0
		if velocity.x == 0:
			anim = "idle"
		elif sprite and sprite.frames.has_animation("walk"):
			anim = "walk"
	else:
		anim = "idle"
		velocity.x = 0
		
	if is_on_wall() and velocity.x != 0:
		direction *= -1

	if sprite:
		if not global.user.following.has(name):
			sprite.flip_h = direction - 1 * (int(mirror_sprite) * 2 - 1)
		sprite.play(anim)
	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement




