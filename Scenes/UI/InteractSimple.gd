extends InteractMain
class_name InteractSimple

onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")


func _ready():
	._ready()
	object = interact_with

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		if touching:
			_add_audio("Effects",name)
			object.visible = false
