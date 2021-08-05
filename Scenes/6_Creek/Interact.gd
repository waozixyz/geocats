extends MainInteract


func _input(_event):
	if _can_interact():
		if name == "CaveToDown":
			player.position.x = 4420
			player.position.y = 4950
		elif name == "CaveToUp":
			player.position.x = 4350
			player.position.y = 3250
		elif name == "JokeRoom":
			SceneChanger.change_scene("JokeRoom", 0, "", 1)
		elif name == "CavityPuzzleRoom":
			SceneChanger.change_scene("CavityPuzzleRoom", 0, "", 1)
		elif name == "GeoCacheRoom":
			SceneChanger.change_scene("GeoCacheRoom", 0, "", 1)
		elif name == "ExitJokeRoom":
			SceneChanger.change_scene("Creek", 2, "", 1)
		elif name == "ExitPuzzleRoom":
			SceneChanger.change_scene("Creek", 1, "", 1)
		elif name == "ExitGeoCache":
			SceneChanger.change_scene("Creek", 3, "", 1)
		elif name == "ToMountain":
			SceneChanger.change_scene("Mountain", 0, "", 1)

