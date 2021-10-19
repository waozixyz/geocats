extends InteractSimple

onready var sprite = $AnimatedSprite

func _process(delta):
	._process(delta)
	if do_something:
		do_something = false
		sprite.visible = true
		_add_audio("SFX",name)
		disabled = true
		PROGRESS.variables["fire"] = true
