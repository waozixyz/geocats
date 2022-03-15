extends Node


func get_scenes(territory):
	match territory:
		Territory.Names.GeoCity: return Territory.GeoCity.keys()
		Territory.Names.Geoterra: return Territory.Geoterra.keys()
		Territory.Names.Glaciokarst: return Territory.Glaciokarst.keys()
		Territory.Names.XAPS: return Territory.XAPS.keys()

enum Names {
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
}

enum Geoterra {
	Creek
	JokeRoom
	CavityPuzzleRoom
	GeoCacheRoom
	Mountain
	GreenCave
	Waterfalls
}

enum Glaciokarst {
	GeoLodge
	Caves
	Battle
}

enum XAPS {
	DesertOutpost
}
