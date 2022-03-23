extends E_Interact

onready var sprite = $AnimatedSprite
onready var pumpkin_ui = get_parent().get_node("CanvasLayer/Pumpkin")

var complete
func _ready():
	complete = PROGRESS.variables.get("NonacoPumpkinPuzzle")
	#pumpkin_ui.visible = false
	._ready()

func _process(_delta):
	if visible:
		disabled = false
		if do_something:
			pumpkin_ui.visible = true if not pumpkin_ui.visible else false
			complete = PROGRESS.variables.get("NonacoPumpkinPuzzle")
			if complete and pumpkin_ui.visible == false:
				#nft.reward(nft_id, false)
				pass
			do_something  = false
			if pumpkin_ui.visible:
				player.disable("pumpkin")
			else:
				player.enable("pumpkin")
		sprite.animation = pumpkin_ui.get_node("AnimatedSprite").animation
	else:
		disabled = true

	if complete:
		get_tree().get_current_scene().theme = "CreepyCity"
