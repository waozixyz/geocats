extends MainInteract


func _input(event):
	if _can_interact():
		if name == "GoDown":
			player.position.x = 1580
			player.position.y = 4080
		elif name == "GoUp":
			player.position.x = 1580
			player.position.y = 2500
		elif name == "ToCreek":
			SceneChanger.change_scene("Creek", 4, "", 1)

