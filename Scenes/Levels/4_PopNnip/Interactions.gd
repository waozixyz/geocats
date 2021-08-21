extends InteractButton


func _input(event):
	if _can_interact():
		object.visible = false
		if name == "GeoCity":
			SceneChanger.change_scene("GeoCity", 1, "WayoWayo", .5)
		elif name == "Arcade":
			SceneChanger.change_scene("Arcade", 0, "", 1)
		elif name == "PopNnip":
			SceneChanger.change_scene("PopNnip", 1, "", .5)

