extends ClickToNode


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var trigger_is_on = false
func _process(delta):
	if trigger_is_on and not node_toggle.visible: 
		if not PROGRESS.variables.has("geoterra_waterfalls_tower_now"):
			PROGRESS.variables["geoterra_waterfalls_tower_now"] = true
			if current_scene.current_song == 0:
				current_scene.next_song()
	if node_toggle.visible:
		trigger_is_on = true
