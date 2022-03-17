extends Teleport
class_name TeleportInternal

onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

export(NodePath) var node_to_go 

var teleporting
var to_go

var tween
func _ready():
	if node_to_go:
		to_go = get_node(node_to_go)
	._ready()
	
func _process(_delta):
	if teleporting and not tween.is_active():
		player.visible = true
		current_scene.set_disable("player", "teleport", false)
		teleporting = false
		if player.followers:
			for follower in player.followers:
				follower.position = Vector2(0,0)

func _input(_event):
	if _can_interact():
		_play_sound()
		if to_go and not teleporting:
			teleporting = true
			current_scene.set_disable("player", "teleport")
			chat_with.visible = false
			player.visible = false
			tween = utils.tween(player, "position", to_go.position)
