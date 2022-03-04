extends Teleport
class_name TeleportExternal

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
export(int) var location = 0

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

func _input(_event):
	if _can_interact():
		global.user.location = location
		SceneChanger.change_scene(utils.find_level_path(territory_name, level_name))
		button.visible = false

		_play_sound()



