extends MovingBody
class_name Player

onready var current_scene = get_tree().get_current_scene()

var horizontal : float = 0.0
var vertical : float = 0.0

var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

var underwater = []
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

var air_friction = 20 #how much you subtract velocity when you start moving horizontally in the air
var water_friction : float = 150
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
func check_wall_slide():
	var raycast
	if left_raycast.is_colliding() && horizontal == -1:
		raycast = left_raycast
	elif right_raycast.is_colliding() && horizontal == 1:
		raycast = right_raycast
	else:
		return false

	var shape_id = raycast.get_collider_shape()
	var collider = raycast.get_collider()
	if collider is StaticBody2D:
		var owner_id = collider.shape_find_owner(shape_id)
		if collider:
			var hit_node = collider.shape_owner_get_owner(owner_id)
			if hit_node:
				if not check_child_collision(hit_node) and not hit_node.is_in_group("end") and not hit_node.get_parent().is_in_group("end"):
					return true


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



# main process loop
var dmg_blink = 0
var velocity_log = []

var no_vx = false
func _physics_process(delta):
	var dfps = delta * global.fps
	# make sure wave particles have the right substance
	waves.substance = water_sub
	._physics_process(delta)
	if current_scene is GeneralLevel and current_scene.is_disabled(name):
		if not no_vx:
			velocity.x = 0
			currentSpeed = 0
			play("idle")
			no_vx = true

	else:
		no_vx = false
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
	if not current_scene.is_disabled("player"):
		global.user.hp -= dmg
	sprite.material.set_shader_param("dmg", true)
	hurt_sfx.play()
	
# main move function
func move():
	var subtractor = 0
	if underwater.size() > 0:
		subtractor += water_friction
		velocity.y *= 0.9
	elif not grounded:
		subtractor += air_friction
	if not no_vx:
		currentSpeed = move_toward(currentSpeed,  maxSpeed - subtractor, acceleration) #accelerate current speed
		_set_vx(currentSpeed * horizontal)#apply curent speed to velocity and multiply by direction
	velocity = move_and_slide(velocity, Vector2.UP, true, 4, max_angle)
 
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

