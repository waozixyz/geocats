extends BasePlayerState

export var wall_slide_speed : float = 100

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.play("slide_wall")
	player.coll_default.disabled = true
	player.coll_slide.disabled = false
	player.velocity = Vector2.ZERO #reset velocity to stop all momentum

func logic(player: KinematicBody2D, delta: float):
	player.vy = wall_slide_speed #override apply_gravity and apply a constant slide speed

	if player.grounded:
		#if you hit a ceiling
		return "idle" #start falling	

	if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
		if player.jumping and not player.is_on_ceiling():
			player.jump(500)
			return "fall"
	else:
		return "fall"
func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.isDoubleJumped = false
	player.coll_default.disabled = false
	player.coll_slide.disabled = true
