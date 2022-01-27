extends Node

func _tween_completed(tween):
	remove_child(tween)
	
# a generic tween for fading effect
func tween_fade(obj, start, end, time = .5):
	var tween = Tween.new()
	tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
	var err = tween.connect("tween_completed", self, "_tween_completed", [tween])
	assert(err == OK)
	add_child(tween)

# get current season
func get_season():
	if Global.edition == "Steam":
		var month = OS.get_datetime()["month"]
		var season = ""
		if month >= 3 and month <= 5:
			season = "Spring"
		elif month >= 5 and month <= 8:
			season = "Summer"
		elif month >= 9 and month <= 11:
			season = "Autumn"
		else:
			season = "Winter"
		return season
	
# load a particle effect
func get_particle_instance(particle_name):
	return load("res://Scenes/Entities/Particles/" + particle_name + ".tscn").instantiate()

func get_scene(scene_name, location):
	var pos = null
	var dir = 1
	match scene_name:
		"TitleScreen":
			return [scene_path + "1-9/0_TitleScreen/TitleScreen.tscn", pos, dir]
		"CatsCradle":
			match location:
				1: 
					pos = Vector2(25, 950 * 0.7)
			return ["res://Scenes/Levels/1_CatCradle/1_CatCradle.tscn", pos, dir]
		"Complex":
			match location:
				1: 
					pos = Vector2(400, 1077)
			return ["res://Scenes/Levels/2_Complex/2_Complex.tscn", pos, dir]
		"GeoCity":
			match location:
				1: 
					pos = Vector2(2630, 1010)
				2:
					pos = Vector2(1023, 1010)
			return ["res://Scenes/Levels/3_GeoCity/3_GeoCity.tscn", pos, dir]
		"PopNnip":
			match location:
				1: 
					pos = Vector2(720, 423)
			return ["res://Scenes/Levels/4_PopNnip/4_PopNnip.tscn", pos, dir]
		"Arcade":
			return ["res://Scenes/Levels/4_PopNnip/Arcade.tscn", pos, dir]
		"DonutShop":
			return ["res://Scenes/Levels/5_DonutShop/5_DonutShop.tscn", pos, dir]
		"Creek":
			match location:
				1: 
					pos = Vector2(5500, 4120)
				2:
					pos = Vector2(2950, 3460)
				3:
					pos = Vector2(8800, 4900)
				4:
					dir = -1
					pos = Vector2(8900, 950)
				5:
					pos = Vector2(4420, 4950)
			return ["res://Scenes/Levels/6_Creek/6_Creek.tscn", pos, dir]
		"CavityPuzzleRoom":	
			return ["res://Scenes/Levels/6_Creek/1_CavityPuzzleRoom.tscn", pos, dir]
		"JokeRoom":	
			return ["res://Scenes/Levels/6_Creek/2_JokeRoom.tscn", pos, dir]
		"GeoCacheRoom":	
			return ["res://Scenes/Levels/6_Creek/3_GeoCacheRoom.tscn", pos, dir]
		"Mountain":	
			return ["res://Scenes/Levels/7_Mountain/7_Mountain.tscn", pos, dir]
		"GeoLodge":
			return ["res://Scenes/Levels/8_GeoLodge/8_GeoLodge.tscn", pos, dir]
		"Caves":
			match location:
				1: 
					pos = Vector2(500, 2120)
			return ["res://Scenes/Levels/9_Caves/9_Caves.tscn", pos, dir]
		"CaveBattle":
			match location:
				1: 
					pos = Vector2(426, 220)
			return ["res://Scenes/Levels/9_Caves/Battle.tscn", pos, dir]
