extends MainInteract


onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")


func _input(_event):
	if _can_interact():
		if name == "UpElevator":
			player.position.x = 1600
			player.position.y = 1000
			affogato.position = player.position

		elif name == "DownElevator":
			player.position.x = 710
			player.position.y = 180
			affogato.position = player.position
		elif name == "HomeDoor":
			SceneChanger.change_scene("CatCradle", 1, "WoodDoorLatchOpen1", 1)
		elif name == "Exit":
			SceneChanger.change_scene("GeoCity", 0, "FootstepsOnGravelFast", 1.5)

