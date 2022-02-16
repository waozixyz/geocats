extends AreaInteract

class_name S_Interact

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var button = $Button

func _process(_delta):
	button.visible = true if touching and player.disable_reasons.size() == 0 else false
	
func _can_interact():
	if visible and Input.is_action_just_pressed("ui_down") && button.visible == true:
		return true
	else:
		return false
