extends MainInteract


func _input(event):
	if _can_interact():
		button.visible = false
		if name == "GoToComplex":
			SceneChanger.change_scene("Complex", 1, "FootstepsOnGravelFast", 1.5)
		if name == "PopNnip":
			SceneChanger.change_scene("PopNnip", 0, "WayoWayo", .5)
		if name == "DonutShop":
			if PROGRESS.variables.get("follow"):
				PROGRESS.variables.follow = false
				PROGRESS.variables.donut_open = true
			if  PROGRESS.variables.get("donut_open"):
				SceneChanger.change_scene("DonutShop", 0, "WoodDoorLatchOpen1", 1)
			else:
				chat_with.visible = true
				chat_with.start("door_closed", true)
				button.visible = true
			

