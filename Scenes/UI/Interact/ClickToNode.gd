extends Area2D
class_name ClickToNode
onready var current_scene = get_tree().get_current_scene()

export(NodePath) var to_toggle
export(bool) var click_close_anywhere = false
export(bool) var disable_e_on_show = true
export(String, FILE, "*.ogg, *.wav") var sound_file = ""
export(float, 0, 100) var sound_volume = 100

var timer
var node_toggle
var colli
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true
	node_toggle = get_node(to_toggle)
	var err = connect("input_event", self, "_input_event")
	assert(err == OK)
	if click_close_anywhere:
		colli = CollisionShape2D.new()
		colli.shape = RectangleShape2D.new()
		colli.shape.set_extents(Vector2(640, 480))
		add_child(colli)

func _process(_delta):
	if click_close_anywhere and node_toggle:
		colli.disabled = false if node_toggle.visible else true
	if disable_e_on_show:
		if node_toggle and node_toggle.visible:
			if not current_scene.is_disabled("e_interact", name):
				current_scene.set_disable("e_interact", name)
		elif current_scene.is_disabled("e_interact", name):
			current_scene.set_disable("e_interact", name, false)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT and node_toggle:
		if timer.time_left == 0:
			AudioManager.play_sound(sound_file, sound_volume)
			node_toggle.visible = false if node_toggle.visible else true
		timer.start()
