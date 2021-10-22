extends InteractSimple

onready var sprite = $AnimatedSprite
onready var platform_idle = $HeadPlatform/Idle
onready var platform_open = $HeadPlatform/Open
onready var platform_open2 = $HeadPlatform/Open2
onready var go_inside_area = $GoInside
var open_mouth
func _ready():
	open_mouth = PROGRESS.variables.get("CavesCatHeadOpen")
	print(open_mouth)
	if open_mouth:
		sprite.animation = "open"
		disabled = true
		sprite.frame = 2
		open_it()
	else:
		sprite.animation = "idle"
		platform_idle.disabled = false
		platform_open.disabled = true
		platform_open2.disabled = true
		
func open_it():
	PROGRESS.variables["CavesCatHeadOpen"] = true
	open_mouth = true
	
	platform_idle.disabled = true
	platform_open.disabled = false
	platform_open2.disabled = false
	
	go_inside_area.disabled = false
	
func _process(delta):
	if not open_mouth:
		go_inside_area.disabled = true
		if do_something and sprite.animation == "idle":
			sprite.animation = "open"
			disabled = true
		
		if sprite.frame == 2:
			open_it()
		
	._process(delta)
