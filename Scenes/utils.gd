extends Node

func toggle(boolean):
	return false if boolean else true

func _tween_completed(_object, _key, tween):
	remove_child(tween)
	
# a generic tween for fading effect
func tween_fade(obj, start, end, time = .5):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
	tween.pause_mode = PAUSE_MODE_PROCESS
	var err = tween.connect("tween_completed", self, "_tween_completed", [tween])
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
	
var particle_emitter = {
	"snow":  preload("res://Scenes/Entities/Particles/Snow.tscn"),
	"confetti": preload("res://Scenes/Entities/Particles/Confetti.tscn")
}
