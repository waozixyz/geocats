extends Node

func get_teleport_sound(sound_name):
	var path = "res://Assets/Teleport/" + sound_name
	return path + find_sound_ext(path)

func get_character_folder(json_file):
	var regex = RegEx.new()
	regex.compile("(.*\/)")
	var result = regex.search(json_file)
	if result:
		return result.get_string()
	else:
		printerr("couldnt get character folder: ", result, json_file)
		return ""

func find_agent_path(agent_name):
	var start = "res://Scenes/Agents/"
	var end = agent_name + ".tscn"
	var file2Check = File.new()
	if file2Check.file_exists(start + end):
		return start + end
	elif file2Check.file_exists(start + agent_name + "/" + end):
		return start + agent_name + '/' + end
	else:
		printerr("wrong path: ", start, end)
func find_level_path(level_territory, level_name):
	var start = "res://Scenes/Levels/"
	var end = level_name + ".tscn"
	var file2Check = File.new()
	if file2Check.file_exists(start + level_territory + "/" + end):
		return start + level_territory + "/" + end
	elif file2Check.file_exists(start + level_territory + "/" + level_name + "/" + end):
		return start + level_territory + "/" + level_name + "/" + end
	else:
		printerr("wrong path: ", start, level_territory, "/", end)

func find_sound_ext(path):
	var file2Check = File.new()
	if file2Check.file_exists(path + ".ogg"):
		return ".ogg"
	elif file2Check.file_exists(path + ".wav"):
		return ".wav"
	else:
		printerr("wrong path: ", path)

func toggle(boolean):
	return false if boolean else true

var tweens = []
func _tween_completed(obj, _key, tween, code):
	remove_child(tween)
	tweens.erase(obj.name + code)
	print(obj, _key, tween)
func tween_position(obj, new_pos, time = 1):
	if not tweens.has(obj.name + '_p'):
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(obj, "position", obj.position, new_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		tween.pause_mode = PAUSE_MODE_PROCESS
		var err = tween.connect("tween_completed", self, "_tween_completed", [tween, '_p'])
		assert(err == OK)
# a generic tween for fading effect
func tween_fade(obj, start, end, time = .5):
	if not tweens.has(obj):
		tweens.append(obj.name + '_f')
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()
		tween.pause_mode = PAUSE_MODE_PROCESS
		var err = tween.connect("tween_completed", self, "_tween_completed", [tween, '_f'])
		assert(err == OK)
		

# get current season
func get_season():
	if global.edition == "Steam":
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
	
var particle_path = "res://Scenes/Environment/Particles/"
enum Particle {
	Snow
	Confetti
}

func _get_particle(p):
	return particle_path + Particle.keys()[p] + ".tscn"
