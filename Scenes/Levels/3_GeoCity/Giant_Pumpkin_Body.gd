extends InteractSimple

onready var giant_pumpkin = $Giant_Pumpkin
onready var pumpkin_ui = get_parent().get_node("CanvasLayer/Pumpkin")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	#pumpkin_ui.visible = false
	hide_interact = false
	giant_pumpkin.play()
	
	
func _process(delta):
	if do_something:
		pumpkin_ui.visible = true if not pumpkin_ui.visible else false
		do_something  = false
