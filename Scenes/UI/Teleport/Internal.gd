extends Teleport
class_name TeleportInternal

onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

export(Vector2) var new_position 

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
		if player.followers:
			for follower in player.followers:
				follower.position = Vector2(0,0)
			print(player.followers)
			#affogato.position = player.position

func _input(_event):
	if _can_interact():
		_play_sound()

		_teleport(new_position)
