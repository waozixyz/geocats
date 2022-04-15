extends Node

func get_teleport_sound(sound_name, sound_ext = ".wav"):
	return "res://Assets/Environment/Teleport/" + sound_name + sound_ext

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

func toggle(boolean):
	return false if boolean else true

var tweens = []
func _tween_completed(obj, _key, tween, code):
	remove_child(tween)
	tweens.erase(obj.name + code)

func tween(obj, prop, val, time = 1):
	if not tweens.has(obj.name + '_' + prop):
		var tween = Tween.new()
		add_child(tween)
		var init_val
		if prop == "fade":
			init_val = obj.modulate.a
			prop = "modulate:a"
		else:
			init_val = obj[prop]
		tween.interpolate_property(obj, prop, init_val, val, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		tween.pause_mode = PAUSE_MODE_PROCESS
		var err = tween.connect("tween_completed", self, "_tween_completed", [tween, '_' + prop])
		assert(err == OK)
		return tween

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
