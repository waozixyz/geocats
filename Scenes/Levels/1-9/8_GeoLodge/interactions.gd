extends InteractButton


func _input(event):
	if _can_interact():
		object.visible = false
		if name == "GoToCaves":
			SceneChanger.change_scene("Caves", 0, "WoodDoorLatchOpen1", 1.5)

