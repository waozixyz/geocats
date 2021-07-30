extends BasePlayerState

export var wall_slide_speed : float = 20

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.play("slide_wall")
	player.coll_default.disabled = true
	player.coll_slide.disabled = false
	player.velocity = Vector2.ZERO #reset velocity to stop all momentum

func logic(player: KinematicBody2D, delta: float):
	player.vy = wall_slide_speed #override apply_gravity and apply a constant slide speed
	if player.jumping and not player.is_on_ceiling():
		if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
			player.vy = -500
		else:
			return "jump"
			
		if not (player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1)):		
			return "fall"
	return "fall"
func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.isDoubleJumped = false
	player.coll_default.disabled = false
	player.coll_slide.disabled = true
