extends InteractButton


func _input(event):
	if _can_interact():
		object.visible = false
		if name == "GoToCity":
			SceneChanger.change_scene("GeoCity", 2, "WoodDoorLatchOpen1", 1.5)

