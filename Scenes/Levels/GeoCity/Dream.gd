extends ShowNode


func _process(delta):
	if do_something:
		# tween player position
		if ui_node.modulate.a == 0:
			utils.tween_position(player, Vector2(1394, 185), transition_time * .5)
			utils.tween_fade(player, 1, 0, transition_time)
		else:
			utils.tween_fade(player, 0, 1, transition_time)
	._process(delta)
