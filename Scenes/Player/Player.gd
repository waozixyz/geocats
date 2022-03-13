extends MovingBody
class_name Player

onready var current_scene = get_tree().get_current_scene()

var horizontal : float = 0.0
var vertical : float = 0.0

var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

var underwater : bool = false
var water_sub : String = "water"
var grounded : bool = false setget ,_get_grounded
var jumping : bool = false setget ,_get_jumping

onready var floor_timer : Timer = $Timers/FloorTimer
onready var platform_timer : Timer = $Timers/PlatformTimer
onready var state_machine: PlayerFSM = $PlayerStates
onready var waves : Particles2D = $Waves

onready var right_raycast = $RightRaycast #path to the right raycast
onready var left_raycast = $LeftRaycast  #path to the left raycast

onready var coll_default = $CollisionDefault
onready var coll_climb = $CollisionClimb
onready var coll_slide = $CollisionSlide

var coyoteStartTime = 0 #ticks when you pressed jump button
var elapsedCoyoteTime = 0 #elapsed time since you last clicked jump
var coyoteDuration = 100 #how many miliseconds to remember a jump press

var isDoubleJumped = false #if you have double jumped

var isJumpPressed : bool = false
var isJumpReleased : bool = false
var jumpInput : int = 0

var previous_state : String setget ,_get_previous_state_tag

var airFriction = 20 #how much you subtract velocity when you start moving horizontally in the air

var currentSpeed = 0 #how much you add to x velocity when moving horizontally
var maxSpeed = 300 #maximum current speed can reach when moving horizontally
var acceleration = 10 #by how much does current speed approach max speed when moving
var decceleration = 35 #by how much does velocity approach when you stop moving horizontally

var dbl_jump_height = 350
var climb_speed : float = 200

# sound effects assets
onready var hurt_sfx = $HurtSFX
onready var jump_shroom_sfx = $JumpShroomSFX
onready var jump_sfx = $JumpSFX
onready var land_water_sfx = $LandWaterSFX
onready var swim_water_sfx = $SwimWaterSFX
# play sounds on jump and run entity jump function
func jump(jumpHeight):
	.jump(jumpHeight)
	if mushroom:
		jump_shroom_sfx.play()
	else:
		jump_sfx.play()

func add_follower(cat):
	if not global.user.following.has(cat.name):
		global.user.following.append(cat.name)
	cat.position = position
	followers.append(cat)
	add_child(cat)
	cat.set_owner(self)
	cat.position = Vector2(0,0)
	if cat.has_node("ChatNPC"):
		cat.get_node("ChatNPC").disabled = true
	cat.no_gravity = true

func remove_follower(cat):
	if global.user.following.has(cat.name):
		global.user.following.remove(cat.name)
	followers.erase(cat)
	cat.position = position
	remove_child(cat)

# play default sprite animations
func default_anim():
	if vertical > 0:
		play("crouch")
	else:
		if vx == 0:
			play("idle")
		else:
			play("walk")

# check if player is donig a wall slide
func check_wall_slide(raycast: RayCast2D, direction: int):
	if raycast.is_colliding() && horizontal == direction:
		var shape_id = raycast.get_collider_shape()
		var collider = raycast.get_collider()
		if not collider is TileMap:
			var owner_id = collider.shape_find_owner(shape_id)
			if collider:
				var hit_node = collider.shape_owner_get_owner(owner_id)

				if hit_node:
					if not check_child_collision(hit_node) and not hit_node.is_in_group("end") and not hit_node.get_parent().is_in_group("end"):
						return true

# move horizontal function
func move_horizontally(subtractor = 0):
	currentSpeed = move_toward(currentSpeed, maxSpeed - subtractor, acceleration) #accelerate current speed
	_set_vx(currentSpeed * horizontal)#apply curent speed to velocity and multiply by direction

# check the previous state player was in
func _get_previous_state_tag():
	var tag = state_machine.previous_state_tag if state_machine else "idle"
	return tag 

var followers = []
# init player
func _ready():
	sprite.play()
	sprite.playing = true
	jump_height = 400
	state_machine.enter_logic(self) 
	._ready()
	if global.user.position:
		position = global.user.position
		sprite.flip_h  = global.user.direction * -1

	for follower in global.user.following:
		var follower_scene = load(utils.find_agent_path(follower))
		if follower_scene:
			add_follower(follower_scene.instance())
		else:
			printerr("follower invalid: ", follower)


# main process loop
var dmg_blink = 0
var velocity_log = []

func _physics_process(delta):
	var dfps = delta * global.fps
	# make sure wave particles have the right substance
	waves.substance = water_sub
	._physics_process(delta)

	if current_scene.is_disabled(name):
		velocity.x = 0
		play("idle")
	else:
		update_inputs()
		state_machine.logic(delta)
		
		# update player hp
		var hp = global.user.hp
		if hp < 100:
			hp += 0.06 * dfps

		if underwater and water_sub == "slime":
			hp -= .6 * dfps
		global.user.hp = hp
	
	move()
	if sprite.material.get_shader_param("dmg"):
		dmg_blink += 1 * (delta * 60)
		if dmg_blink >= 15:
			sprite.material.set_shader_param("dmg", false)
			dmg_blink = 0

	# follow player logic
	velocity_log.append(velocity)
	if velocity_log.size() > 10:
		for follower in followers:
			var pos_x = round(follower.position.x) 
			var pvel_x = velocity_log[0].x

			# reset position to be static
			follower.velocity = -velocity

			if abs(follower.position.y) < 100 and abs(follower.position.x) < 100:
				if state_machine.active_state.tag == "climb":
					var x_speed = currentSpeed
					if x_speed < 50:
						x_speed = 50
					if follower.position.x > 5:
						follower.velocity.x = -x_speed
					elif follower.position.x < -5:
						follower.velocity.x = x_speed
					else:
						if follower.position.y > 40:
							follower.velocity.y = -climb_speed
						elif follower.position.y < 30:
							follower.velocity.y = climb_speed
						else:
							follower.velocity.y = 0
				else:
					if velocity_log[0].y == 0:
						follower.apply_gravity(12)
					
					follower.velocity.y += velocity_log[0].y
					# callibrate position

					if sprite.flip_h and pos_x > 60 and pvel_x < 0:
						follower.velocity.x -= currentSpeed
						follower.sprite.flip_h = not sprite.flip_h
					elif pos_x < -60 and pvel_x > 0:
						follower.velocity.x += currentSpeed
						follower.sprite.flip_h = not sprite.flip_h
			else:
				follower.apply_gravity(12)
		velocity_log.pop_front()

# update keyboard inputs
func update_inputs():
	horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


	isJumpPressed = Input.is_action_just_pressed("jump")
	isJumpReleased = Input.is_action_just_released("jump")
	
	#set coyote jump time (remember jump presses to make the jump more forgiving)
	if jumpInput == 0 && isJumpPressed:
		#if you press jump and your not already in coyote time
		jumpInput = int(isJumpPressed) #set jump to 1
		coyoteStartTime = OS.get_ticks_msec() #start timer
	elapsedCoyoteTime = OS.get_ticks_msec() - coyoteStartTime

	if jumpInput != 0 && elapsedCoyoteTime > coyoteDuration:
		#if timer expires and your in coyote time
		jumpInput = 0 #reset jump input
		coyoteStartTime = 0 #reset timer
	
	if is_on_floor():
		floor_timer.start()

# player damage function
func damage(dmg):
	global.user.hp -= dmg
	sprite.material.set_shader_param("dmg", true)
	hurt_sfx.play()
	
# main move function
func move():
	velocity = move_and_slide(velocity, Vector2.UP, true)

# animation helper function
func play(animation:String):
	if sprite:
		if animation == "slide_wall" and coll_slide.disabled:
			sprite.position = Vector2(4, -6) if sprite.flip_h else Vector2(-4, -6) 
		else:
			sprite.position = Vector2(0, 0)
		if sprite.animation == animation:
			return
		sprite.play(animation)

	###########################################################
# Setget
###########################################################
func _get_vx():
	return vx
func _set_vx(val:float):
	if val != 0:
		sprite.flip_h = (val < 0)

	velocity.x = val
	vx = val

func _get_vy():
	return vy
func _set_vy(val:float):
	velocity.y = val
	vy = val

func _get_grounded():
	grounded = not floor_timer.is_stopped() if floor_timer else false
	return grounded

func _get_jumping():
	return jumpInput
###########################################################

