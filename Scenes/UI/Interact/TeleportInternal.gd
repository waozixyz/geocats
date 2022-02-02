extends S_Interact
class_name TeleportInternal, "res://Assets/UI/Debug/teleport_icon.png"

onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(Vector2) var new_position 
export(float) var sound_volume = 1.0

var teleporting
var dest_x
var dest_y

var tween = Tween.new()
func _ready():
	add_child(tween)
	._ready()
	
func _teleport(new_pos: Vector2):
	player.visible = false
	player.disable("teleport")

	teleporting = true

	tween.interpolate_property(player, "position",
		player.position, new_pos, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _process(_delta):
	if teleporting:
		chat_with.visible = false
	if teleporting and not tween.is_active():
		player.visible = true
		player.enable("teleport")
		teleporting = false
		affogato.position = player.position

func _input(_event):
	if _can_interact():
		AudioManager.play_sound(sound_effect, sound_volume)

		_teleport(new_position)
