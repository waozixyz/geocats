extends InteractButton


func _input(_event):
	if _can_interact():
		if name == "CaveToDown":
			_add_audio("Effects", "GroundCatJokeRoom", false)
			_teleport(4420, 4950)
		elif name == "CaveToUp":
			_add_audio("Effects", "GroundCatJokeRoom", false)
			_teleport(4350, 3240)
		elif name == "JokeRoom":
			SceneChanger.change_scene("JokeRoom", 0, "OrganicSmashLilCave", 1)
		elif name == "CavityPuzzleRoom":
			#SceneChanger.change_scene("CavityPuzzleRoom", 0, "OrganicTumbleCave2", 1)
			chat_with.start("rubble_block", true, false)
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

