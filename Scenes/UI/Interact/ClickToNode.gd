extends Area2D

export(NodePath) var to_toggle
export(bool) var click_close_anywhere = false
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

func _process(delta):
	if click_close_anywhere and node_toggle:
		colli.disabled = false if node_toggle.visible else true

func _input_event( viewport, event, shape_idx):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT and node_toggle:
		if timer.time_left == 0:
			node_toggle.visible = false if node_toggle.visible else true
		timer.start()
