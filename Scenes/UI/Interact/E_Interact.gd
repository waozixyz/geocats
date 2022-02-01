extends AreaInteract
class_name E_Interact, "res://Assets/UI/Debug/soundeffect_icon.png"

onready var player =  get_tree().get_current_scene().get_node("Default/Player")

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(float) var sound_volume = 1
export (bool) var hide_interact_after_input = true

var do_something 
var playing = false
var interact_with

func _ready():
	._ready()
	var e_button = preload("res://Scenes/UI/Interact/E_Interact.tscn").instance()
	add_child(e_button)
	interact_with = e_button.get_node("Control")
	
func _process(delta):

	if touching and not playing:
		interact_with.visible = true

	else:
		interact_with.visible = false
	interact_with.visible
func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact")  and interact_with.visible and not disabled and not playing:
		if touching:
			do_something = true
			if sound_effect and not playing:
				AudioManager.play_sound(sound_effect, sound_volume, self, player)
				playing = true
			if hide_interact_after_input:
				interact_with.visible = false
			
