extends LockedItem

onready var sprite = $Sprite


func _process(delta):
	._process(delta)
	PROGRESS.quests["geoterra_kitten_quest"] = true
	if PROGRESS.variables.get(unlock_var) and PROGRESS.variables[unlock_var]:
		sprite.frame = 2
		disabled = true
	else:
		if dia_started:
			sprite.frame = 1
		else:
			sprite.frame = 0
