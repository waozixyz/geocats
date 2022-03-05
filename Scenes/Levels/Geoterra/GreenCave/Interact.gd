extends InteractButton


func _input(event):
	if _can_interact():
		if name == "GoDown":
			_teleport(1580, 4080)
		elif name == "GoUp":
			_teleport(1580, 2500)
		elif name == "ToCreek":
			SceneChanger.change_scene("Creek", 4, "", 1)

