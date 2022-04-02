extends GeneralLevel


onready var lethe = $Lethe
func _ready():
	if 'Lethe' in global.user.following or PROGRESS.quests.has("geoterra_kitten_quest_complete") and PROGRESS.quests["geoterra_kitten_quest_complete"]:
		remove_child(lethe)
	
func _physics_process(delta):
	var follow = PROGRESS.variables.get("geoterra_lethe_visible")

	if follow and not 'Lethe' in global.user.following and dialogue.modulate.a == 0:
		remove_child(lethe)
		add_follower(lethe)

	
