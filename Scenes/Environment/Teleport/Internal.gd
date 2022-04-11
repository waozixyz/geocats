extends Teleport
class_name TeleportInternal

export(NodePath) var node_to_go 

var teleporting
var to_go

var tween
func _ready():
	if node_to_go:
		to_go = get_node(node_to_go)
	._ready()
	
func _process(_delta):
	if tween and tween.is_active():
		for follower in current_scene.followers:
			if follower.follow_order >= temp_order:
				follower.visible = false
	
	elif teleporting:
		current_scene.set_disable("chat_with", "teleport", false)
		player.visible = true
		current_scene.set_disable("player", "teleport", false)
		teleporting = false
		for follower in current_scene.followers:
			follower.visible = true
			follower.position = player.position
			follower.follow_order = 0
			player.position_log = []
			player.anime_log = []

var temp_order = 0
func _input(_event):
	if _can_interact():
		_play_sound()
		if to_go and not teleporting:
			current_scene.set_disable("chat_with", "teleport")
			teleporting = true
			current_scene.set_disable("player", "teleport")
			player.visible = false
			temp_order = player.position_log.size() - 1
			tween = utils.tween(player, "position", to_go.position)
