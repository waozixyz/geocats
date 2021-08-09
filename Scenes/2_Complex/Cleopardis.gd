extends Entity

var anim = "idle"

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite2
	to_rotate = $ViewportContainer
	._ready()


