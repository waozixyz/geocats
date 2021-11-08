extends AnimatedSprite

# this was created to avoid needing the playing bool true in the scene
# which keeps rewriting the scene file and causing merge issues

func _ready():
	play()
