extends MovingBody

onready var player =  get_parent().get_node("Player")

func _ready():
	no_rotate = true
	._ready()
	init = false
	jump_height = 15

onready var chat = $Area2D

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

	var follow = PROGRESS.variables.get("follow")
	if scene_name == "Arcade" and not follow:
		visible = true
		chat.disabled = false
	elif not follow && scene_name != "DonutShop":
		visible = false
		chat.disabled = true
		return
	elif scene_name == "DonutShop":
		visible = true
		jump_height = 0
		chat.disabled = false
	
	velocity.x = 0

	if player and follow:
		if not init:
			visible = true
			if player:
				position = player.position
			init = true
		chat.disabled = true
		
		
		if position.y > player.position.y + margin and ticks == 20:
			next_jump_height = 400
		
		if position.x < player.position.x - margin:
			add_x += mov_speed
		if position.x > player.position.x + margin:
			add_x -= mov_speed

		#if player.isDoubleJumped:
		#	jump(player.dbl_jump_height)
		if player.isJumpPressed:
			next_jump_height = player.jump_height

		if add_x != 0:
			velocity.x += add_x * .1 
			add_x -= add_x * .1

		if position.y < player.position.y - margin:
			fall_through()
		else:
			if ticks > 100:
				jump_height = 300
				ticks = 0
			else:
				jump_height = 15 + next_jump_height
		if on_ladder and player.vx == 0:
			
			if position != player.position:
				position += (player.position - position) * .05 * dfps
			tween_to_ladder()
			climbing = true
		else:
			if climbing:
				position.y = player.position.y 
				climbing = false
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
			
