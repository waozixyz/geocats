extends MainInteract


func _input(_event):
	if _can_interact():
		SceneChanger.change_scene("Complex", 0, "WoodDoorLatchOpen1", 1)
		button.visible = false
