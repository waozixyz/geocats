extends Control
class_name Feline

func _unselect_others(device):
	for child in device.get_children():
		child.selected = false

func _action(_child):
	return

func _get_id(device, id, diff):
	var start_id = id
	id += diff
	if id < 0:
		id += device.get_child_count()
	if id > device.get_child_count() - 1:
		id -= device.get_child_count()

	while device.get_child(id).disabled:
		id += diff
		if id < 0:
			id = device.get_child_count() - 1
		if id > device.get_child_count() - 1:
			id = 0
		if id == start_id:
			return -1

	return id
func _get_ids(device):
	current_id = -1
	prev_id = -1
	next_id = -1
	for id in device.get_child_count():
		var child = device.get_child(id)
		if child.selected and not child.disabled:
			current_id = id
			
			prev_id = _get_id(device, id, -1)
			next_id = _get_id(device, id, +1)
			return


var current_id
var prev_id
var next_id
func input(device, event):
	_get_ids(device)
	if event.is_action_pressed("ui_accept"):
		var child = device.get_child(current_id)
		if child and not child.disabled:
			_action(child)
	if prev_id != -1:
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
			_unselect_others(device)
			device.get_child(prev_id).selected = true
	if next_id != -1:
		if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
			_unselect_others(device)
			device.get_child(next_id).selected = true
