extends GeneralLevel

onready var affogato = $Affogato
func _ready():
	if 'Affogato' in global.user.following:
		remove_child(affogato)
	
func _physics_process(delta):
	var follow = PROGRESS.variables.get("arcade_affogato_follow")

	if follow and not 'Affogato' in global.user.following:
		remove_child(affogato)
		add_follower(affogato)

	
