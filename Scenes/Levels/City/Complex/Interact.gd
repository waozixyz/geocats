extends InteractButton



func _input(_event):
	if _can_interact():
		if name == "UpElevator":
			_add_audio("Effects", "Vending_Machine_2", false)
			_teleport(1600, 1000)

		elif name == "DownElevator":
			_add_audio("Effects", "Vending_Machine_2", false)
			_teleport(710, 180)
			

		elif name == "Exit":
			SceneChanger.change_scene("GeoCity", 0, "FootstepsOnGravelFast", 1.5)

