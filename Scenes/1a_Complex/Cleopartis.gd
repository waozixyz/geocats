extends Entity

var anim = "idle"

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	._ready()


