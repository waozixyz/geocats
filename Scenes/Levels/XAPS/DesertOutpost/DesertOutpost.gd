extends GeneralLevel



func _process(delta):
	._process(delta)
	if PROGRESS.variables.has("teleport") and PROGRESS.variables["teleport"]:
		PROGRESS.variables["teleport"] = false
		global.user.location = 0
		var sound = AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
		sound.pause_mode = PAUSE_MODE_PROCESS
		SceneChanger.change_scene("Geoquarium")
