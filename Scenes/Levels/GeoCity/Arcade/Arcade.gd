extends GeneralLevel

onready var affogato = $Affogato
func _physics_process(delta):
	var follow = PROGRESS.variables.get("affogato_follow")

	if follow:
		player.add_follower(affogato)
