extends Entity

var anim = "idle"

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	._ready()

	
func _physics_process(delta):
	

	sprite.play("idle")
	sprite.animation = anim

