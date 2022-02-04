extends E_Interact

class_name LockedItem

onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")

export(NodePath) var item
export(String, FILE, "") var dialogue_file = ""

var feline_path = "res://Assets/Feline/test.json"


func _process(delta):
	if do_something:
		dialogue.initiate(feline_path, feline_path + "feline_locked_door.json")
