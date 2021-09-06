extends InteractSimple

onready var sprite = $AnimatedSprite
onready var platform_idle = $HeadPlatform/Idle
onready var platform_open = $HeadPlatform/Open
onready var go_inside_area = $GoInside
func _process(delta):
	if do_something and sprite.animation == "idle":
		sprite.animation = "open"
		disabled = true
	if sprite.frame == 2:
		platform_idle.visible = false
		platform_open.visible = true
		go_inside_area.disabled = false
	else:
		go_inside_area.disabled = true
	._process(delta)
