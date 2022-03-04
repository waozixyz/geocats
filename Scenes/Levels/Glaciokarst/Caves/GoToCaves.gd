extends InteractSimple


func _process(delta):
	if do_something:
		SceneChanger.change_scene("Caves", 1, "WoodDoorLatchOpen1", 1)
	._process(delta)
