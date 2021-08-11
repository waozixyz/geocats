extends MainInteract


func _input(_event):
	if _can_interact():
		if name == "CaveToDown":
			AudioStreamManager.play("res://Assets/Sfx/SFX/GroundCatJokeRoom.ogg")
			player.position.x = 4420
			player.position.y = 4950
		elif name == "CaveToUp":
			AudioStreamManager.play("res://Assets/Sfx/SFX/GroundCatJokeRoom.ogg")
			player.position.x = 4350
			player.position.y = 3240
		elif name == "JokeRoom":
			SceneChanger.change_scene("JokeRoom", 0, "OrganicSmashLilCave", 1)
		elif name == "CavityPuzzleRoom":
			SceneChanger.change_scene("CavityPuzzleRoom", 0, "OrganicTumbleCave2", 1)
		elif name == "GeoCacheRoom":
			SceneChanger.change_scene("GeoCacheRoom", 0, "OrganicSmashLilCave", 1)
		elif name == "ExitJokeRoom":
			SceneChanger.change_scene("Creek", 2, "OrganicTumbleCave2", 1)
		elif name == "ExitPuzzleRoom":
			SceneChanger.change_scene("Creek", 1, "OrganicSmashLilCave", 1)
		elif name == "ExitGeoCache":
			SceneChanger.change_scene("Creek", 3, "OrganicTumbleCave2", 1)
		elif name == "ToMountain":
			SceneChanger.change_scene("Mountain", 0, "Effects_Footsteps_Fast_Sand", 1)

