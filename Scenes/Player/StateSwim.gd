extends BasePlayerState

export var anim_speed : float = 1.5
var original_anim_speed : float

func enter_logic(player: KinematicBody2D):
	player.velocity *= 0.5

func logic(player: KinematicBody2D, _delta: float):
	if player.on_ladder and player.vx == 0:
		return "climb"

	player.apply_gravity()

	if player.jumping:
		return "jump"
	if player.underwater.size() > 0:
		if player.horizontal != 0 or not player.grounded:
			player.waves.emitting = true

		else:
			player.waves.emitting = false
			player.play("idle")

		return null
	player.waves.emitting = false
	if player.grounded:
		return "walk" if player.horizontal != 0 else "idle"

	return "fall"

func exit_logic(player: KinematicBody2D):
	player.waves.emitting = false
