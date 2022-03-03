extends AreaInteract
class_name E_Interact, "res://Assets/UI/Debug/soundeffect_icon.png"

onready var player = get_tree().get_current_scene().get_player()
onready var dialogue = get_tree().get_current_scene().get_node("Default/CanvasLayer/Dialogue")

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(float) var sound_volume = 1

var do_something 
var playing = false
var interact_with
var disable_sound = false
var hide_when_playing = true
export var require_grounded = false
export var disable_player = ""
export var button_reappear_delay = 0.5
func _ready():
	._ready()
	var e_button = preload("res://Scenes/UI/Interact/E_Interact.tscn").instance()

	add_child(e_button)
	interact_with = e_button.get_node("Control")
	interact_with.modulate.a = 0
	
func _check_grounded():
	return true if require_grounded and player.is_on_floor() or not require_grounded else false
		
func _is_not_disabled():
	return _check_grounded() and interact_with and (not playing or not hide_when_playing) and not disabled and (player.disable_reasons.size() == 0 or (not disable_player.empty() and player.disable_reasons.has(disable_player)))
var timer = -1
func _process(delta):
	if timer >= 0:
		timer += delta
		disabled = true
		if timer >= button_reappear_delay:
			timer = -1
			disabled = false
	if touching  and _is_not_disabled():
		if interact_with.modulate.a == 0:
			utils.tween_fade(interact_with, 0, 1, 0.2)
				
	elif interact_with and interact_with.modulate.a == 1:
		utils.tween_fade(interact_with, 1, 0, 0.2)

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact") and _is_not_disabled() and interact_with.modulate.a > 0:
		if touching and dialogue.modulate.a == 0:
			do_something = true
			if not disable_player.empty():
				player.disable(disable_player)
			if sound_effect and (not playing or not hide_when_playing) and not disable_sound:
				AudioManager.play_sound(sound_effect, sound_volume, false, self, player)
				playing = true
			
