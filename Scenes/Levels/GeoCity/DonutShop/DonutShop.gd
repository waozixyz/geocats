extends GeneralLevel
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
var affogato
var move_to_pos = false

func _ready():
	global.user.following = ["Affogato"]
var step = 0
func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport")

	if teleport:
		PROGRESS.variables["teleport"] = false
		global.user.location = 0
		AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
		SceneChanger.change_scene(utils.find_level_path("Geoterra", "Creek"))


	if "Affogato" in global.user.following:
		affogato = player.get_node("Affogato")
		player.remove_follower(affogato)
		add_child(affogato)
		player.disable("donutshop")
		global.user.following.remove("Affogato")
		move_to_pos = true
	elif move_to_pos:
		affogato.apply_gravity()
		if affogato.is_on_floor():
			affogato.jump(20)
		if step == 0:
			if affogato.position.x < 120:
				affogato.velocity.x = 120
			elif affogato.position.x < 220:
				affogato.velocity.x = 105
				if affogato.is_on_floor():
					affogato.jump(320)
			elif affogato.is_on_floor():
				affogato.velocity.x = 0
				step = 1
		elif step == 1 and affogato.is_on_floor():
			affogato.jump(260)
			step = 2
		elif step == 2:
			affogato.velocity.x = 100
			if affogato.is_on_floor():
				affogato.jump(190)
				step = 3
		elif step == 3:
			if affogato.is_on_floor():
				affogato.jump(140)
				step = 4
		elif step == 4:
			affogato.velocity.x = 220
			if affogato.position.x > 700:
				move_to_pos = false
				remove_child(affogato)
				player.enable("donutshop")
				player.position.x += 10
