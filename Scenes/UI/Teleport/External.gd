extends Teleport
class_name TeleportExternal

onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")

enum Territory {
	GeoCity
	Geoterra
	Geodesert
	Geoquarium
}

enum GeoCity {
	CatsCradle
	Complex
	GeoCity
	PopNnip
	Arcade
	DonutShop
}

enum Geoterra {
	Creek
}
export(Territory) var territory
export(GeoCity) var geocity
export(Geoterra) var geoterra
export(int) var location = 0
export(String) var progress_required = ""

var feline_path = "res://Assets/Feline/"

func _get_level_name():
	match territory:
		Territory.GeoCity: return GeoCity.keys()[geocity]
		Territory.Geoterra: return Geoterra.keys()[geoterra]

var territory_name
var level_name
func _ready():
	territory_name = Territory.keys()[territory]
	level_name = _get_level_name()

func _input(_event):
	if _can_interact():

		if PROGRESS.variables.get(progress_required) or not progress_required:
			global.user.location = location
			SceneChanger.change_scene(utils.find_level_path(territory_name, level_name))
			button.visible = false
			_play_sound()
		elif progress_required and not dialogue.visible:

			dialogue.initiate(feline_path, feline_path + "feline_locked_door.json")
