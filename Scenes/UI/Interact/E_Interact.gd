extends AreaInteract
class_name E_Interact, "res://Assets/UI/Debug/soundeffect_icon.png"

onready var player =  get_tree().get_current_scene().get_node("Default/Player")

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(float) var sound_volume = 1

var do_something 
var playing = false
var interact_with
var disable_sound = false


func _ready():
	._ready()
	var e_button = preload("res://Scenes/UI/Interact/E_Interact.tscn").instance()
	add_child(e_button)
	interact_with = e_button.get_node("Control")
	interact_with.modulate.a = 0
	
func _process(_delta):
	if interact_with:
		if touching and not playing and not disabled:
			if interact_with.modulate.a == 0:
				utils.tween_fade(interact_with, 0, 1, 0.2)
		elif interact_with.modulate.a == 1:
			utils.tween_fade(interact_with, 1, 0, 0.2)

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact") and interact_with and interact_with.modulate.a > 0 and not disabled and not playing:
		if touching:
			do_something = true
			if sound_effect and not playing and not disable_sound:
				AudioManager.play_sound(sound_effect, sound_volume, self, player)
				playing = true
			
