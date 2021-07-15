extends KinematicBody2D
class_name Player

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var horizontal : int = 0
var vertical : int = 0
var up : bool = false 
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

var underwater : bool = false
var grounded : bool = false setget ,_get_grounded
var jumping : bool = false setget ,_get_jumping

var ladder_x : float

onready var jump_timer : Timer = $Timers/JumpTimer
onready var dbl_jump_timer : Timer = $Timers/DoubleJumpTimer
onready var floor_timer : Timer = $Timers/FloorTimer
onready var ladder_timer : Timer = $Timers/LadderTimer
onready var platform_timer : Timer = $Timers/PlatformTimer
onready var sprite : AnimatedSprite = $AnimatedSprite
onready var state_machine: PlayerFSM = $PlayerStates
onready var tween : Tween = $Tween
onready var waves : Particles2D = $Waves

onready var coll_default = $CollisionDefault
onready var coll_climb = $CollisionClimb

var coyoteStartTime = 0 #ticks when you pressed jump button
var elapsedCoyoteTime = 0 #elapsed time since you last clicked jump
var coyoteDuration = 100 #how many miliseconds to remember a jump press

var isDoubleJumped = false #if you have double jumped

var isJumpPressed : bool = false
var isJumpReleased : bool = false
var jumpInput : int = 0

var on_ladder : bool = false
var previous_state : String setget ,_get_previous_state_tag
func _get_previous_state_tag():
	return state_machine.previous_state_tag

func _ready():
	state_machine.enter_logic(self) 

# one way collding platform
var current_platforms = []
var disabled_platforms = []
var fall_through_timer = 0
var fall_through_time = 1000

func fall_through():
	for platform in current_platforms:
		platform.disabled = true
		disabled_platforms.insert(disabled_platforms.size(), platform)
	fall_through_timer = fall_through_time


func _physics_process(delta):
	if fall_through_timer > 0:
		fall_through_timer -= OS.get_ticks_msec() * .01
	else:
		for platform in disabled_platforms:
			platform.disabled = false

		disabled_platforms = []
	current_platforms = []
	if is_on_floor():
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			for child in collision.collider.get_children():
				if _check_child_collision(child):
					current_platforms.insert(current_platforms.size(), child)
			var normal = collision.normal
			
			if normal.x > -.7 && normal.x < .7:
				var slope_angle = normal.dot(Vector2(0,-1)) - 1
				var mul = 1
				if normal.x < 0:
					mul = -1
				sprite.rotation = -slope_angle * 4 * mul
	#else:
	#	rotation = rotation * .99
	#rotation_degrees = -30
	update_inputs()
	state_machine.logic(delta)
	emit_signal("hud", "%s" % state_machine.active_state.tag)

		
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

func apply_gravity (delta: float):
	velocity += Vector2.DOWN * gravity

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
	jumping = not jump_timer.is_stopped()
	return jumpInput
###########################################################

func _on_PlatformTimer_timeout():
	collision_layer = 1 | 2

func _check_child_collision(child):
	if (child is CollisionShape2D || child is CollisionPolygon2D) && child.is_one_way_collision_enabled():
		return true
	else:
		return false
