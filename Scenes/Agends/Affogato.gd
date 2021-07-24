extends Entity

onready var player =  get_parent().get_node("Player")

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	no_rotate = true
	._ready()
	init = false


onready var chat = $Area2D

var f = 0.002
var elapsed = 0
var ticks = 0
var margin = 50
var mov_speed = 8
var jump_height = 15
var init = false
var lastDiff = 0
var diff = 0
var climbing = false

func _physics_process(delta):
	velocity.x = 0
	if PROGRESS.variables.get("follow"):
		if not init:
			visible = true
			position = player.position
			init = true
		chat.disabled = true

		if position.x < player.position.x - margin:
			position.x += mov_speed
		elif position.x > player.position.x + margin:
			position.x -= mov_speed
		if position.y > player.position.y + margin * 2:
			jump_height = 600 
		elif position.y > player.position.y + margin:
			jump_height = 400
		elif position.y < player.position.y - margin:
			fall_through()
		else:
			if ticks > 100:
				jump_height = 300
				ticks = 0
			else:
				jump_height = 15
		if player.state_machine.active_state.tag == "climb":
			if position != player.position:
				position += (player.position - position) * .05
			climbing = true
		else:
			if climbing:
				position.y = player.position.y 
				climbing = false

	ticks += 1
	if is_on_floor():
		jump(jump_height)
	if not climbing:
		velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement

		
