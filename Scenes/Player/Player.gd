extends KinematicBody2D

#State Vars
var states = ["idle", "run", "crouch", "climb", "dash", "fall", "jump", "double_jump"] #list of all states
var currentState = states[0] #what state's logic is being called every frame
var previousState = null #last state that was being calles

#Nodes & paths
onready var sprite = $AnimatedSprite #path to the player's sprite

onready var RightRaycast = $RightRaycast #path to the right raycast
onready var LeftRaycast = $LeftRaycast  #path to the left raycast

#Input Vars
var movementInput = 0 #will be 1, -1, 0 depending on if you are holding right, left, or nothing
var movementInputY = 0 #will be 1, -1, 0 depending on if you are holding up, d, or nothing
var lastDirection = 1 #last direction pressed that is not 0

var isJumpPressed = 0 #will be 1 on the frame that the jump button was pressed
var isJumpReleased #will be 1 on the frame that the jump button was released

var isUpPressed = 0 #will be 1 on the frame that the up button was pressed
var isDownPressed = 0 #will be 1 on the frame that the down button was pressed

var coyoteStartTime = 0 #ticks when you pressed jump button
var elapsedCoyoteTime = 0 #elapsed time since you last clicked jump
var coyoteDuration = 100 #how many miliseconds to remember a jump press

var jumpInput = 0 #jump press with coyote time

var isDashPressed #will be 1 on the frame that the dash button was pressed

#Movement Vars
var velocity = Vector2.ZERO #linear velocity applied to move and slide

var currentSpeed = 0 #how much you add to x velocity when moving horizontally
var maxSpeed = 300 #maximum current speed can reach when moving horizontally
var acceleration = 50 #by how much does current speed approach max speed when moving
var decceleration = 80 #by how much does velocity approach when you stop moving horizontally

var airFriction = 60 #how much you subtract velocity when you start moving horizontally in the air

#idle
var idleDurration = 1800  #how long cat should be idle until it blinks
var blinkDurration = 100 # how long cat should be in the blink anim
var idleStartTime = 0#how many miliseconds passed when you become idle
var elapsedIdleTime = 0 #how many milisecconds elapsed since you started being idle

#dash
var dashSpeed = 120 #how fast you dash
var dashDurration = 200  #how long you dash for (in milisecconds)

var canDash = true #can the character dash
var dashStartTime #how many miliseconds passed when you started dashing
var elapsedDashTime #how many milisecconds elapsed since you started dashing
var dashDirection = 1 #direction of dash will be 1 or -1 if you are dashing left or right

#fall
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumpBufferStartTime  = 0 #ticks when you ran of the platform
var elapsedJumpBuffer = 0 #how many seconds passed in the jump nuffer
var jumpBuffer = 100 #how many miliseconds allowance you give jumps after you run of an edge


#jump
var jumpHeight = 256  #How high the peak of the jump is in pixels
var jumpVelocity #how much to apply to velocity.y to reach jump height

#double jump
var doubleJumpHeight = 128 #How high the peak of the double jump is in pixels
var doubleJumpVelocity #how much to apply to velocity.y to reach double jump height

var isDoubleJumped = false #if you have double jumped

#wall slide
var wallSlideSpeed = 50 #how fast you slide on a wll

#wall jump
var wallJumpHeight = 128 #how high you want the peak of your wall jump to be in pixels
var wallJumpVelocity #how much to apply to velocity.y to reach wall jump height


# sprite animation
var anim = "idle"

# ladder
var on_ladder = false

#functions
func _ready():
	#use kin functions to set jump velocites
	jumpVelocity = -sqrt(2 * gravity * jumpHeight)
	doubleJumpVelocity = -sqrt(2 * gravity * doubleJumpHeight)
	
	wallJumpVelocity = -sqrt(2 * gravity * jumpHeight)		

onready var coll_climb = $CollisionClimb
onready var coll_slide = $CollisionSlide
onready var coll_default = $CollisionDefault
	
func default_coll():
	if anim == "slide_wall":
		coll_slide.disabled = false
		coll_default.disabled = true
	else:
		coll_slide.disabled = true
		coll_default.disabled = false

func _physics_process(delta):
	default_coll()
		
	get_input()

	apply_gravity(delta)
	
	call(currentState + "_logic", delta) #call the current states main method

	velocity = move_and_slide(velocity, Vector2.UP) #aply velocity to movement

	sprite.flip_h = lastDirection - 1 #flip sprite depending on which direction you last moved in

	sprite.play(anim)
	sprite.animation = anim

func default_anim():
	if velocity.x == 0:
		anim = "idle"
	else:
		anim = "walk"

func get_input():
	#set input vars
	movementInput = Input.get_action_strength("right") - Input.get_action_strength("left") #set movement input to 1,-1, or 0
	movementInputY = Input.get_action_strength("down") - Input.get_action_strength("up")
	if movementInput != 0:
		lastDirection = movementInput #set last direction if movement input isnt 0
		
	isUpPressed = Input.is_action_just_pressed("up")
	isDownPressed = Input.is_action_just_pressed("down")
	
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
	
	isDashPressed = Input.is_action_just_pressed("dash")



func apply_gravity(delta):
	#apply gravity in every state except dash
	if currentState != "dash":
		velocity.y += gravity * delta


func set_state(new_state : String):
	#update state values
	previousState = currentState
	currentState = new_state
	
	#call enter/exit methods
	if previousState != null:
		call(previousState + "_exit_logic")
	if currentState != null:
		call(currentState + "_enter_logic")

#Functions used across multiple states

func move_horizontally(subtractor):
	currentSpeed = move_toward(currentSpeed, maxSpeed, acceleration) #accelerate current speed
	
	velocity.x = currentSpeed * movementInput #apply curent speed to velocity and multiply by direction
	
func move_vertically():
	currentSpeed = move_toward(currentSpeed, maxSpeed, acceleration) #accelerate current speed
	
	velocity.y = currentSpeed * movementInputY #apply curent speed to velocity and multiply by direction
	velocity.x = 0

func jump(jumpVelocity):
	velocity.y = 0 #reset velocity
	velocity.y = jumpVelocity #apply velocity
	canDash = true #allow the player to dash when they jump
	

func default_logic():
	if jumpInput:
		#jump if you press button
		jump(jumpVelocity)
		set_state("jump")
	
	if isDashPressed:
		#dash if you press button
		set_state("dash")
		
	if isUpPressed && on_ladder:
		set_state("climb")
		
	if Input.get_action_strength("down") > 0:
		set_state("crouch")

#State Functions
func climb_enter_logic():
	anim = "climb"
func climb_logic(delta):
	move_vertically()
	if jumpInput:
		#jump if you press button
		jump(jumpVelocity)
		set_state("jump")
	if not on_ladder || is_on_floor() && movementInputY >= 0:
		set_state("idle")
	if movementInput != 0 and movementInputY == 0:
		set_state("run")
func climb_exit_logic():
	pass

func crouch_enter_logic():
	pass

func crouch_logic(delta):
	default_logic()
	if Input.get_action_strength("down") > 0:
		anim = "crouch"
	else:
		set_state("idle")
	move_horizontally(0)

func crouch_exit_logic():
	pass


func idle_enter_logic():
	anim = "idle"
	idleStartTime = OS.get_ticks_msec() #set dash start time to total ticks since the game started
		
func idle_logic(delta):
	elapsedIdleTime = OS.get_ticks_msec() - idleStartTime #set elapsed idle time
	if elapsedIdleTime > idleDurration:
		anim = "blink"
		if elapsedIdleTime - idleDurration > blinkDurration:
			idleStartTime = OS.get_ticks_msec()
	else:
		anim = "idle"
	
	default_logic()
		
	if movementInput != 0:
		#start running if you press a movement button
		set_state("run")
	velocity.x = move_toward(velocity.x, 0, decceleration) #deccelerate


func idle_exit_logic():
	currentSpeed = 0 #reset current speed (we do this here to keep momentum on run jumps)


func run_enter_logic():
	anim = "walk"

func run_logic(delta):
	default_logic()
	
	if !is_on_floor():
		#if your not on a floor, start falling and set jumpbuffer start time
		jumpBufferStartTime = OS.get_ticks_msec()
		set_state("fall")
		
	
	if movementInput == 0:
		#if your not pressing a move button go idle
		set_state("idle")
	else:
		#if pressing move button start moving
		move_horizontally(0)
	
func run_exit_logic():
	pass



func fall_enter_logic():
	pass

func fall_logic(delta):
	default_anim()
	move_horizontally(airFriction) #move horizontally
	elapsedJumpBuffer = OS.get_ticks_msec() - jumpBufferStartTime #set elapsed time for jump buffer
	if isUpPressed && on_ladder:
		set_state("climb")
	if isJumpPressed:
		#if you press jump
		if !isDoubleJumped && elapsedJumpBuffer > jumpBuffer:
			#and jump is pressed outside the jump buffer window, and this is your first double jump
			jump(doubleJumpVelocity) #apply double jump velocity
			set_state("double_jump") #set state to double jump
		
		if elapsedJumpBuffer < jumpBuffer:
			#if your in the jump buffer window
			if previousState == "run":
				#and your previpus state is run
				jump(jumpVelocity) #jump with ground velocity
				set_state("jump") #set state to jump
			if previousState == "wall_slide":
				#and your previous state is wall slide
				jump(wallJumpVelocity) #jump with wall jump velocity
				set_state("wall_jump") #set state to wall jump
	
	if isDashPressed && canDash:
		#dash if you press dash button
		set_state("dash")
	
	if is_on_floor():
		#if player is on a floor
		set_state("run") #set state to run (we set to run to keep momentum)
		isDoubleJumped = false #reset is double jumped
		
	if LeftRaycast.is_colliding() && movementInput == -1 || RightRaycast.is_colliding() && movementInput == 1:
		#if your raycast is coliding and you are trying to move in that direction
		set_state("wall_slide")
	

func fall_exit_logic():
	jumpBufferStartTime = 0 #reset jump buffer start time



func dash_enter_logic():
	dashDirection = lastDirection #set dash direction (we use lastDirection to make sure we dash even when idle)
	dashStartTime = OS.get_ticks_msec() #set dash start time to total ticks since the game started
	
	velocity = Vector2.ZERO #set velocity to zero
	
	anim = "idle"
	sprite.modulate = Color.purple #tint the player sprite purple

func dash_logic(delta):
	elapsedDashTime = OS.get_ticks_msec() - dashStartTime #set elapsed dash time
	
	velocity.x += dashSpeed * dashDirection #add dash speed to velocity and multiply by dash direction
	
	if elapsedDashTime > dashDurration:
		#if elapsed dash time is greater then the dash durration
		set_state(previousState) #go back to the previous state

func dash_exit_logic():
	velocity = Vector2.ZERO  #reset velocity to zero
	if !is_on_floor():
		canDash = false #limit the amount of air dashes someone can do
	
	sprite.modulate = Color.white #untint the sprite


func jump_enter_logic():
	pass

func jump_logic(delta):
	default_anim()
	move_horizontally(airFriction) #move horizontally and subtract airfriction from max speed
	if isUpPressed && on_ladder:
		set_state("climb")
	if velocity.y < 0:
		#if you are rising
		if isJumpReleased:
			#and you release jump button
			velocity.y /= 2 #lower velocity
			
		if isJumpPressed && !isDoubleJumped:
			#if its your first time double jumping and you press the jump button
			jump(doubleJumpVelocity)  #apply double jump velocity
			set_state("double_jump") #set state to double jump
		
		if isDashPressed && canDash:
			#if you can dash and you press the dash button
			set_state("dash") #set state to dash
			 
		if is_on_ceiling():
			#if you hit a ceiling
			set_state("fall") #start falling
	else:
		#if you are no longer rising
		set_state("fall") #fall
	
func jump_exit_logic():
	pass



func double_jump_enter_logic():
	isDoubleJumped = true #make sure you can only double jump once
	
func double_jump_logic(delta):
	default_anim()
	move_horizontally(airFriction) #move horizontally and subtract airfriction from max speed
	if isUpPressed && on_ladder:
		set_state("climb")
	if velocity.y < 0:
		#if you are rising
		if isJumpReleased:
			#and you release jump button lower velocity
			velocity.y /= 2
		
		if isDashPressed && canDash:
			#and you press dash button and you can dash
			set_state("dash") #dash
		
		if is_on_ceiling():
			#and you hit a ceiling 
			set_state("fall") #fall
	else:
		#if you are no longer rising
		set_state("fall") #fall

func double_jump_exit_logic():
	pass



func wall_slide_enter_logic():
	velocity = Vector2.ZERO #reset velocity to stop all momentum
	
	anim = "slide_wall"
	
func wall_slide_logic(delta):
	velocity.y = wallSlideSpeed #override apply_gravity and apply a constant slide speed
	
	if LeftRaycast.is_colliding() && movementInput != -1 || RightRaycast.is_colliding() && movementInput != 1:
		#if your raycast is coliding and you are trying to move in that direction
		jumpBufferStartTime = OS.get_ticks_msec() #start jump buffer timer
		set_state("fall") #set state to fall
	#this could be done in one long if statement but I split it up to make it easiar to read
	if !LeftRaycast.is_colliding() && movementInput == -1 || !RightRaycast.is_colliding() && movementInput == 1:
		#if you are holding in a direction but no longer coliding with a wall in that direction
		set_state("fall")
	
	if is_on_floor():
		#if you hit the floor set state to idle
		jumpBufferStartTime = OS.get_ticks_msec() #start jump buffer timer
		set_state("idle")
		
	
	if isDashPressed:
		#dash if you press dash button
		set_state("dash")
	
	if isJumpPressed:
		jump(wallJumpVelocity) #jump with walljump y velocity
		set_state("wall_jump")

func wall_slide_exit_logic():
	isDoubleJumped = false #allow you to double jump again when you wall jump



func wall_jump_enter_logic():
	currentSpeed = 0 #erase momentum form run

func wall_jump_logic(delta):
	default_anim()
	move_horizontally(airFriction) #move horizontally
	if isUpPressed && on_ladder:
		set_state("climb")
	#if you want to add a wall jump thrust you can do so by:
	#deifining a wallJumpThrust variable
	#and putting velocity.x += wallJumpThrust * lastDirection here
	
	if velocity.y < 0:
		#if you are rising
		if isJumpReleased:
			#and you release jump button lower velocity
			velocity.y /= 2
			
		if isJumpPressed && !isDoubleJumped:
			#doublejump if you press button and its your first timme double jumping
			#we use isJumpPressed here instead of jumpInput so we dont imeadiatly double jump when we originaly jump
			jump(doubleJumpVelocity)
			set_state("double_jump")
		
		if isDashPressed:
			set_state("dash")
			
		if is_on_ceiling():
			#and you hit a ceiling fall
			set_state("fall")
	else:
		#if your not rising
		set_state("fall")

func wall_jump_exit_logic():
	canDash = true #allow the players to dash again if they wall jump
