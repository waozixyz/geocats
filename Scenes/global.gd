extends Node
var player_position
var player_direction
func _enter_tree():
	get_tree().set_auto_accept_quit(false)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			data.saveit()
			get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		data.saveit()
		get_tree().quit()
