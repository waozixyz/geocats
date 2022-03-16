extends Teleport
class_name TeleportExternal

onready var current_scenes = get_tree().get_current_scene()

export(Territory.Names) var territory
export(Territory.GeoCity) var geocity
export(Territory.Geoterra) var geoterra
export(Territory.Glaciokarst) var glaciokarst
export(Territory.XAPS) var xaps
export(int) var next_loc = 0
export(int) var this_loc = 0
export(bool) var use_parent_pos = false
func _get_level_name():
	match territory:
		Territory.Names.GeoCity: return Territory.GeoCity.keys()[geocity]
		Territory.Names.Geoterra: return Territory.Geoterra.keys()[geoterra]
		Territory.Names.Glaciokarst: return Territory.Glaciokarst.keys()[glaciokarst]
		Territory.Names.XAPS: return Territory.XAPS.keys()[xaps]
		
var territory_name
var level_name
			
func _ready():
	territory_name = Territory.Names.keys()[territory]
	level_name = _get_level_name()
	var locations = current_scene.locations
	if this_loc > 0:
		if locations.size() < this_loc + 1:
			locations.resize(this_loc + 1)
		if use_parent_pos:
			locations[this_loc] = get_parent().position + position
		else:
			locations[this_loc] = position
	current_scene.locations = locations
func _input(_event):
	if _can_interact():
		global.user.location = next_loc
		SceneChanger.change_scene(territory_name, level_name)
		button.visible = false

		_play_sound()



