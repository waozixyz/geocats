extends E_Interact

class_name LockedItem

export(NodePath) var item_node

export(String) var unlock_var

export(String, FILE, "*.wav, *.ogg") var unlock_sound
export(float) var unlock_volume = 1
export(String) var relock_var

func _relock():
	to_unlock.visible = false
	to_unlock.disabled = true
	if not to_unlock.disable_player.empty():
			current_scene.set_disable("player", to_unlock.disable_player, false)
var to_unlock 
func _check_unlocked():
	if to_unlock:
		if PROGRESS.variables.get(relock_var) and PROGRESS.variables[relock_var]:
			_relock()
		elif PROGRESS.variables.get(unlock_var) and PROGRESS.variables[unlock_var] :
			to_unlock.visible = true
			disabled = true
		else:
			_relock()
			
func _ready():
	to_unlock = get_node(item_node)
	if not to_unlock:
		printerr("item to unlock not found: " + item_node)
	_check_unlocked()
	if dialogue_file.empty():
		disabled = true

func _process(delta):
	_check_unlocked()
