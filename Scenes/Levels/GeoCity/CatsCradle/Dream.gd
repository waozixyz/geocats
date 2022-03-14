extends ShowNode

onready var music = get_tree().get_current_scene().get_music()
func _process(delta):
	if do_something:
		# tween player position
		if ui_node.modulate.a == 0:
			utils.tween(player, "position", Vector2(1394, 185), transition_time * .5)
			utils.tween(player, "fade", 0, transition_time)
			music.pitch_scale = .4
		else:
			utils.tween(player, "fade", 1, transition_time)
			music.pitch_scale = 1
	._process(delta)
