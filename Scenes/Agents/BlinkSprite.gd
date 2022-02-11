extends AnimatedSprite
export var freq_range = [0.0007, 0.008]
var f
var elapsed = 0
var ticks = 0

func _ready():
	play()
	f = rand_range(freq_range[0], freq_range[1])
		
func _physics_process(_delta):

	ticks = OS.get_ticks_msec() * f
	frame = int(ticks) % 3
	if OS.get_ticks_msec() - elapsed > 100:
		elapsed = OS.get_ticks_msec()
		f = rand_range(freq_range[0], freq_range[1])

