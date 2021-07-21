extends Entity
class_name Player

var horizontal : int = 0
var vertical : int = 0
var up : bool = false 

var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

var underwater : bool = false
var grounded : bool = false setget ,_get_grounded
var jumping : bool = false setget ,_get_jumping

var ladder_x : float

onready var floor_timer : Timer = $Timers/FloorTimer
onready var ladder_timer : Timer = $Timers/LadderTimer
onready var platform_timer : Timer = $Timers/PlatformTimer
onready var state_machine: PlayerFSM = $PlayerStates
onready var tween : Tween = $Tween

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

var on_ladder : bool = false
var previous_state : String setget ,_get_previous_state_tag

var airFriction = 5 #how much you subtract velocity when you start moving horizontally in the air

var currentSpeed = 0 #how much you add to x velocity when moving horizontally
var maxSpeed = 600 #maximum current speed can reach when moving horizontally
var acceleration = 100 #by how much does current speed approach max speed when moving
var decceleration = 120 #by how much does velocity approach when you stop moving horizontally

func default_anim():
	if vertical > 0:
		play("crouch")
	else:
		if vx == 0:
			play("idle")
		else:
			play("walk")

func check_wall_slide(raycast: RayCast2D, direction: int):
	if raycast.is_colliding() && horizontal == direction:
		var shape_id = raycast.get_collider_shape()
		var collider = raycast.get_collider()
		if collider:
			if collider is TileMap:
				for child in collider.get_children():
					if check_child_collision(child) and child.is_in_group("end"):
						return false
				return true
			else:
				var hit_node = collider.shape_owner_get_owner(shape_id)
				if hit_node:
					if not check_child_collision(hit_node) and not hit_node.is_in_group("end") and not hit_node.get_parent().is_in_group("end"):
						return true

func move_horizontally(subtractor):
	currentSpeed = move_toward(currentSpeed, maxSpeed, acceleration) #accelerate current speed
	_set_vx(currentSpeed * horizontal)#apply curent speed to velocity and multiply by direction

func move_vertically():
	currentSpeed = move_toward(currentSpeed, maxSpeed, acceleration) #accelerate current speed
	_set_vy(currentSpeed * vertical)#apply curent speed to velocity and multiply by direction
	_set_vx(0)

func _get_previous_state_tag():
	return state_machine.previous_state_tag

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	state_machine.enter_logic(self) 
	._ready()
	if global.player_position:
		position = global.player_position

func _physics_process(delta):
	._physics_process(delta)
	update_inputs()
	state_machine.logic(delta)
	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
		
func update_inputs():
	horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	up = Input.is_action_pressed("ui_up")
	
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

func move():
	var old = velocity
	velocity = move_and_slide(velocity, Vector2.UP, false)

func play(animation:String):
	if sprite.animation == animation:
		return
	sprite.play(animation)

func tween_to_ladder():
	var target = Vector2(ladder_x, position.y)

	tween.interpolate_property(self, "position", position, target,
		0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func can_climb():
	return on_ladder and ladder_timer.is_stopped()

###########################################################
# Setget
###########################################################
func _get_vx():
	return vx
func _set_vx(val:float):
	if val != 0:
		sprite.flip_h = (val < 0)
		coll_slide.position.x = 12 * (int(val > 0) * 2 -1)

	velocity.x = val
	vx = val

func _get_vy():
	return vy
func _set_vy(val:float):
	velocity.y = val
	vy = val

func _get_grounded():
	grounded = not floor_timer.is_stopped()
	return grounded

func _get_jumping():
	return jumpInput
###########################################################

