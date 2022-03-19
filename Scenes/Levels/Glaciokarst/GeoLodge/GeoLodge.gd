extends GeneralLevel


func _process(_delta):
	if  PROGRESS.variables.get("DesertOutpostUnlocked") and PROGRESS.variables["DesertOutpostUnlocked"]:
		if not global.user.visited.has("XAPS"):
			global.user.visited["XAPS"] = ["DesertOutpost"]
