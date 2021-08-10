extends Node

var player_position
var player_direction
var crt_noise = 0.0

var data =  {
	"scene": "CatCradle",
	"location": 0,
	"present": true,
	"prog_var": {},
	"prog_dia": {},
	"player_hp": 100.0,
	"nav_visible": {},
	"nav_unlocked": {"CatCradle": true},
}

func _enter_tree():
	get_tree().set_auto_accept_quit(false)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Data.saveit()
		get_tree().quit()
