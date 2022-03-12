extends E_Interact

func _process(_delta):
	if do_something:
		global.user.location = 1 
		SceneChanger.change_scene("Glaciokarst", "Caves")
		do_something = false
