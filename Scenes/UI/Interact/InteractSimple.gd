extends InteractMain
class_name InteractSimple

onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")

func _ready():
	._ready()
	object = interact_with

func _process(delta):
	._process(delta)
	if nft_possible:
		nft.update(touching, nft_id)

		if nft.main.visible or chat_with.visible or nft.login.visible or global.updating:
			object.visible = false
		elif touching:
			object.visible = true

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact") and object.visible:
		if touching:
			if nft_possible:
				nft.reward(nft_id)
			_add_audio("Effects",name)
			object.visible = false

