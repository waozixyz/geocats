extends AreaInteract
class_name ChatNPC, "res://Assets/UI/Debug/chat_npc_icon.png"

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")

export(bool) var has_parent = false
export(String) var character_name = name
export(String, DIR) var character_folder = ""

export(String, FILE, "*.json") var json_file = ""
export(String, FILE, "*.ogg, *.wav") var sound_file = ""

func _get_default_path():
	if character_folder.empty() and not json_file.empty():
		return utils.get_character_folder(json_file)
	else:
		return character_folder + "/" + character_name.to_lower()
func _ready():
	if not character_folder.empty() or not json_file.empty():
		var file2Check = File.new()
		if json_file.empty():
			json_file = _get_default_path() + ".json"
		if sound_file.empty():
			if file2Check.file_exists(_get_default_path() + ".ogg"):
				sound_file = _get_default_path() + ".ogg"
			elif file2Check.file_exists(_get_default_path() + ".wav"):
				sound_file = _get_default_path() + ".wav"
	else:
		disabled = true
		printerr("missing character folder or json file for: ", name)
var active : bool
var completed :bool
func show_chat():
	active = true
	chat_with.visible = true
	chat_with.get_node("Label").text = character_name

func hide_chat():
	active = false
	chat_with.visible = false
	dialogue.exit()

func _process(_delta):
	if touching and not active and not disabled:
		show_chat()
	elif (disabled or not touching) and active:
		hide_chat()
	
	if has_parent and "idle" in get_parent():
		get_parent().idle = true if dia_started else false

	
var dia_started
func _input(_event):
	if touching and json_file and Input.is_action_just_pressed("interact") and dialogue.modulate.a == 0:
		if chat_with.visible:
			dialogue.initiate(json_file)
			dialogue.modulate.a = 0.1
			dia_started = true
			
			chat_with.visible = false
			AudioManager.play_sound(sound_file)
		else:
			active = false
			completed = true
			return

	if dia_started and dialogue.modulate.a == 0:
		dia_started = false
