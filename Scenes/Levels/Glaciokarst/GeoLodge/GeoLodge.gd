extends GeneralLevel


func _process(_delta):
	if  PROGRESS.variables.get("enable_location") and PROGRESS.variables["enable_location"]:

		if not global.user.visited.has("XAPS"):
			global.user.visited["XAPS"] = ["DesertOutpost"]
		PROGRESS.variables["enable_location"] = false
