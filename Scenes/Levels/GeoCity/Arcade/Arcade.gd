extends GeneralLevel

onready var affogato = $Affogato
func _physics_process(delta):
	var follow = PROGRESS.variables.get("affogato_follow")

	if follow and not 'Affogato' in global.user.follawable:
		player.add_follower(affogato)
		remove_child(affogato)
		player.add_child(affogato)
		affogato.set_owner(player)
		affogato.position = Vector2(0,0)
