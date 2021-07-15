extends BasePlayerState

export var jump_height : float = 600

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.jump(jump_height)

func logic(player: KinematicBody2D, delta: float):
	player.default_anim()
	player.move_horizontally(player.airFriction)
		
	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"

	if player.vy < 0:
		#if you are rising
		if player.isJumpReleased:
			#and you release jump button
			player.vy /= 2 #lower velocity
			
		if player.isJumpPressed && !player.isDoubleJumped:
			return "double_jump" #set state to double jump
		if player.is_on_ceiling():
			#if you hit a ceiling
			return "fall" #start falling
	else:
		return "fall"
	
	if player.grounded:
		return "idle"
	return null
