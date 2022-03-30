extends E_Interact

class_name LockedItem

export(NodePath) var item_node

export(String) var unlock_var

export(String, FILE, "*.wav, *.ogg") var unlock_sound
export(float) var unlock_volume = 1
export(String) var relock_var
export(bool) var one_use = true
export(bool) var disable_locked_item = true

func _set_locked_item(flag):
	if disable_locked_item:
		if to_unlock is KinematicBody2D:
			for child in to_unlock.get_children():
				if child is ChatNPC:
					child.disabled = flag
		else:
			to_unlock.disabled = flag

func _relock():
	to_unlock.visible = false
	_set_locked_item(false)
	if to_unlock is E_Interact and not to_unlock.disable_player.empty():
		current_scene.set_disable("player", to_unlock.disable_player, false)
	if not dialogue_file:
		disabled = true
var to_unlock 
func _check_unlocked():
	if to_unlock:
		if relock_var and PROGRESS.variables.get(relock_var) and PROGRESS.variables[relock_var]:
			_relock()
		elif PROGRESS.variables.get(unlock_var) and PROGRESS.variables[unlock_var]:
			to_unlock.visible = true
			_set_locked_item(true)
			if one_use:
				disabled = true
			
		else:
			_relock()
			
func _ready():
	to_unlock = get_node(item_node)
	if not to_unlock:
		printerr("item to unlock not found: " + item_node)
	_check_unlocked()

func _process(_delta):
	_check_unlocked()

