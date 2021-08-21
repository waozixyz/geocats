extends AnimatedSprite
var f = 0.002
var elapsed = 0
var ticks = 0
func _physics_process(delta):

	ticks = OS.get_ticks_msec() * f
	frame = int(ticks) % 3
	if OS.get_ticks_msec() - elapsed > 100:
		elapsed = OS.get_ticks_msec()
		f = rand_range(0.0007, 0.008)
		if name == "npc2":
			f -= 0.0002
