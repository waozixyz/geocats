extends GeneralLevel

var affogato 
var move_to_pos = false

var step = 0
func _physics_process(_delta):
	var teleport = PROGRESS.variables.get("teleport")

	if teleport:
		global.user.location = 0
		var sound = AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
		sound.pause_mode = PAUSE_MODE_PROCESS
		SceneChanger.change_scene("Geoterra", "Creek")
		PROGRESS.variables["teleport"] = false

	if "Affogato" in global.user.following:
		for follower in followers:
			if follower.name == "Affogato":

				remove_follower(follower, false)
				follower.position = player.position
				affogato = follower
				set_disable("player", "donutshop")
				
				move_to_pos = true

	elif move_to_pos and affogato:

		if affogato.is_on_floor():
			affogato.jump(22)
		if step == 0:
			if affogato.position.x < 130:
				affogato.velocity.x = 125
			elif affogato.position.x < 220:
				affogato.velocity.x = 105
				if affogato.is_on_floor():
					affogato.jump(340)
			elif affogato.is_on_floor():
				affogato.velocity.x = 0
				step = 1
		elif step == 1 and affogato.is_on_floor():
			affogato.jump(280)
			step = 2
		elif step == 2:
			affogato.velocity.x = 100
			if affogato.is_on_floor():
				affogato.jump(190)
				step = 3
		elif step == 3:
			if affogato.is_on_floor():
				affogato.jump(140)
				step = 4
		elif step == 4:
			affogato.velocity.x = 220
			if affogato.position.x > 700:
				move_to_pos = false
				remove_child(affogato)
				set_disable("player", "donutshop", false)
				player.position.x += 10
