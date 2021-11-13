extends InteractSimple

onready var giant_pumpkin = $Giant_Pumpkin
onready var pumpkin_ui = get_parent().get_node("CanvasLayer/Pumpkin")

var complete
func _ready():
	complete = PROGRESS.variables.get("NonacoPumpkinPuzzle")
	#pumpkin_ui.visible = false
	hide_interact = false
	giant_pumpkin.play()
	nft_id = "Nonaco Puzzle Pumpkin"
	nft_possible = true
	._ready()

func _process(delta):
	if do_something:
		pumpkin_ui.visible = true if not pumpkin_ui.visible else false
		complete = PROGRESS.variables.get("NonacoPumpkinPuzzle")
		if complete and pumpkin_ui.visible == false:
			nft.reward(nft_id, false)
		do_something  = false
		if pumpkin_ui.visible:
			player.disable("pumpkin")
		else:
			player.enable("pumpkin")
	giant_pumpkin.animation = pumpkin_ui.get_node("AnimatedSprite").animation


	
	if complete:
		get_tree().get_current_scene().theme = "CreepyCity"
