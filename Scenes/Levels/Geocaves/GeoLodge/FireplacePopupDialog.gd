extends InteractSimple

onready var panel = get_tree().get_current_scene().get_node("PumpkinCode/Panel")
onready var sprite = $Sprite
func show_code():
	panel.visible = true

func _ready():
	hide_interact = false
	._ready()
	panel.get_node("Label").text = str(global.pumpkin_code)

func _process(delta):
	._process(delta)
	if do_something:
		panel.visible = true if not panel.visible else false
		do_something = false
	
	if panel.visible and not touching:
		panel.visible = false
	if touching:
		sprite.modulate.a = .7
	else:
		sprite.modulate.a = .4

