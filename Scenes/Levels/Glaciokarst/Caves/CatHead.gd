extends LockedItem


onready var idle = $Idle
onready var open = $Open
onready var sprite = $AnimatedSprite

func _check_colliders(now = false):
	if PROGRESS.variables.get(unlock_var) == true or now or global.user.location == 1:
		sprite.animation = "open"
		sprite.play()
		disabled = true
		if global.user.location == 1:
			player.visible = false
			player.disable("cave")
	else:
		for collider in open.get_children():
			collider.disabled = true
		for collider in idle.get_children():
			collider.disabled = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_check_colliders()

func _process(delta):
	if do_something:
		do_something = true
		_check_colliders(true)

	if not PROGRESS.variables.get(unlock_var) and sprite.frame == 2:
		PROGRESS.variables[unlock_var] = true
		for colliders in open.get_children():
			colliders.disabled = false
		for colliders in idle.get_children():
			colliders.disabled = true
			
		if global.user.location == 1:
			player.visible = true
			player.enable("cave")
