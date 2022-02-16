extends GeneralLevel
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
var affogato
var move_to_pos = false
func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport"] = false
		#SceneChanger.change_scene("Creek", 0, "WayoWayo", 1)

	if "Affogato" in global.user.following:
		affogato = player.get_node("Affogato")
		player.remove_follower(affogato)
		add_child(affogato)
		player.disable("donutshop")
		global.user.following.remove("Affogato")
		move_to_pos = true
	elif move_to_pos:
		affogato.apply_gravity(delta)
		if affogato.position.x < 320:
			affogato.velocity.x = 140
		else:
			affogato.velocity.x = 0
		if affogato.is_on_floor() and affogato.position.y > 100:
			affogato.jump(400)
		if affogato.position.y < 100:
			affogato.velocity.x = 260
		if affogato.position.x > 700:
			move_to_pos = false
			remove_child(affogato)
			player.enable("donutshop")
			player.position.x += 10
