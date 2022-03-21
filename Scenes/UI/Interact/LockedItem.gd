extends E_Interact

class_name LockedItem

export(NodePath) var item_node

export(String) var unlock_var

export(String, FILE, "*.wav, *.ogg") var unlock_sound
export(float) var unlock_volume = 1

var to_unlock 
func _check_unlocked():
	if to_unlock:
		if PROGRESS.variables.get(unlock_var):
			to_unlock.visible = true
			disabled = true
		else:
			to_unlock.visible = false
	
func _ready():
	to_unlock = get_node(item_node)
	if not to_unlock:
		printerr("item to unlock not found: " + item_node)
	_check_unlocked()
	if dialogue_file.empty():
		disabled = true

func _process(delta):
	_check_unlocked()
