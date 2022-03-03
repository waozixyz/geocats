extends ChatNPC


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if touching:
		player.position.x -= 20

		player.sprite.flip_h = -1

