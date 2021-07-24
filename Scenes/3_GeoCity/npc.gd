extends Entity

var anim = "idle"

func _ready():
	sprite = $ViewportContainer/Viewport/AnimatedSprite
	to_rotate = $ViewportContainer
	._ready()

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP, true) #apply velocity to movement
