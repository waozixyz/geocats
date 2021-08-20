extends InteractMain

class_name InteractButton


onready var affogato =  get_tree().get_current_scene().get_node("Default/Affogato")


var tween = Tween.new()
func _ready():
	object = $Button
	add_child(tween)
	._ready()

var teleport
var dest_x
var dest_y

func _teleport(x, y):
	player.visible = false
	player.disabled = true

	teleport = true


	tween.interpolate_property(player, "position",
		player.position, Vector2(x, y), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	

func _process(delta):
	._process(delta)
	if teleport:
		chat_with.visible = false
	if teleport and not tween.is_active():
		player.visible = true
		player.disabled = false
		teleport = false
		affogato.position = player.position
		

func _can_interact():
	if Input.is_action_just_pressed("ui_down") && object.visible == true && not chat_with.started && not player.disabled:
		return true
	else:
		return false
