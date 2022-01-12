extends AreaInteract
class_name ChatNPC

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")

export(bool) var has_parent = false
export(String) onready var character_name = name
export(String, FILE, "*.json") var json_file = ""
export(String, FILE, "*.ogg, *.wav") var sound_file = ""

var active : bool
var completed :bool
func show_chat():
	active = true
	chat_with.visible = true
	chat_with.get_node("Label").text = character_name

func hide_chat():
	active = false
	chat_with.visible = false


func _process(delta):
	if touching and not active:
		show_chat()
	elif (disabled or not touching) and active:
		hide_chat()
	
	if active and has_parent and "idle" in get_parent():
		get_parent().idle = true if chat_with.started else false

	
func _input(_event):
	if touching and json_file and Input.is_action_just_pressed("interact") and not dialogue.visible:
		if chat_with.visible:
			dialogue.initiate(json_file)
			chat_with.visible = false
			_play_sound(sound_file)
		else:
			active = false
			completed = true
			return
	

