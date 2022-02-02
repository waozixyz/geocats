extends Teleport
class_name TeleportExternal


export(int) var location = 0
var level_territory = ""
var level_name = ""

func _input(_event):
	if _can_interact():
		global.user.location = location
		SceneChanger.change_scene(utils.find_level_path(level_territory, level_name))
		button.visible = false
		_play_sound()

