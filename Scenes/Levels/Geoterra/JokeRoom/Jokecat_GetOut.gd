extends ChatNPC


var talked
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if touching and dialogue.modulate.a == 1:
		talked = true
	if dialogue.modulate.a < .3 and talked:
		player.position.x -= 20
		player.sprite.flip_h = -1
		talked = false
