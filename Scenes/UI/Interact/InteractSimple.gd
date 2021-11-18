extends InteractMain
class_name InteractSimple

onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")

var do_something 
var hide_interact = true

func _ready():
	._ready()
	object = interact_with

func _process(delta):
	._process(delta)
	if nft_possible:
		if nft.main.visible or chat_with.visible or nft.login.visible or Global.updating:
			object.visible = false
		elif touching:
			object.visible = true

func _input(_event):
	# when i press the interact key (e)
	if not chat_with.started and Input.is_action_just_pressed("interact") and object.visible and not disabled:
		if touching:
			do_something = true
			_add_audio("Effects",name)
			if hide_interact:
				object.visible = false

