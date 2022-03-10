extends Teleport
class_name TeleportExternal

onready var locations = get_tree().get_current_scene().locations

enum Territory {
	GeoCity
	Geoterra
	Glaciokarst
	XAPS
	Geoquarium
}

enum GeoCity {
	CatsCradle
	Complex
	GeoCity
	PopNnip
	Arcade
	DonutShop
	Dream
}

enum Geoterra {
	Creek
	JokeRoom
	CavityPuzzleRoom
	GeoCacheRoom
	Mountain
	GreenCave
	Watterfalls
}

enum Glaciokarst {
	GeoLodge
	Caves
	Battle
}

enum XAPS {
	DesertOutpost
}


export(Territory) var territory
export(GeoCity) var geocity
export(Geoterra) var geoterra
export(Glaciokarst) var glaciokarst
export(XAPS) var xaps
export(int) var next_loc = 0
export(int) var this_loc = 0

func _get_level_name():
	match territory:
		Territory.GeoCity: return GeoCity.keys()[geocity]
		Territory.Geoterra: return Geoterra.keys()[geoterra]
		Territory.Glaciokarst: return Glaciokarst.keys()[glaciokarst]
		Territory.XAPS: return XAPS.keys()[xaps]
		
var territory_name
var level_name
			
func _ready():
	territory_name = Territory.keys()[territory]
	level_name = _get_level_name()
	if this_loc > -1:
		if locations.size() < this_loc:
			locations.resize(this_loc)
		locations.insert(this_loc, position)
func _input(_event):
	if _can_interact():
		global.user.location = next_loc
		SceneChanger.change_scene(utils.find_level_path(territory_name, level_name))
		button.visible = false

		_play_sound()



