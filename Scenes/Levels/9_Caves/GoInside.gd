extends InteractSimple


func _process(delta):
	if do_something:
		SceneChanger.change_scene("CaveBattle", 0, "WoodDoorLatchOpen1", 1)
	._process(delta)
