extends TeleportExternal
class_name TeleportGeoCity

enum Levels {
	CatsCradle
	Complex
	GeoCity
	PopNnip
	Arcade
	DonutShop
}

export(Levels) var level

func _ready():
	level_territory = "GeoCity"
	level_name = Levels.keys()[level]
	
