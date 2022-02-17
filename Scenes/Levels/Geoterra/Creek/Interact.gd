extends InteractButton


func _input(_event):
	if _can_interact():
		elif name == "ExitJokeRoom":
			SceneChanger.change_scene("Creek", 2, "OrganicTumbleCave2", 1)
		elif name == "ExitPuzzleRoom":
			SceneChanger.change_scene("Creek", 1, "OrganicSmashLilCave", 1)
		elif name == "ExitGeoCache":
			SceneChanger.change_scene("Creek", 3, "OrganicTumbleCave2", 1)
		elif name == "ToMountain":
			SceneChanger.change_scene("Mountain", 0, "Effects_Footsteps_Fast_Sand", 1)

