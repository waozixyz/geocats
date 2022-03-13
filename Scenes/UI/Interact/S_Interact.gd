extends AreaInteract

class_name S_Interact

onready var current_scene =  get_tree().get_current_scene()
onready var player =  current_scene.get_player()
onready var button = $Button

func _process(_delta):
	if button:
		button.visible = true if touching and not current_scene.is_disabled("player") else false
	else:
		printerr("button missing for: ", name)
func _can_interact():
	if visible and Input.is_action_just_pressed("ui_down") && button.visible == true:
		return true
	else:
		return false
