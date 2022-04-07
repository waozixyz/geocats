extends GeneralLevel

onready var affogato = $Affogato
func _ready():
	if not 'Affogato' in global.user.following and PROGRESS.variables.get("arcade_affogato_follow"):
		remove_child(affogato)



func _physics_process(delta):
	if has_node(affogato.name) and PROGRESS.variables.get("arcade_affogato_follow") and not 'Affogato' in global.user.following:
		add_follower(affogato)
	
