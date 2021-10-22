extends InteractMain
class_name InteractChat

var active : bool

var parent_name : String
var convo_file : String
var music_file : String

func _get_complex_convo():
	var scene_name = get_tree().get_current_scene().name
	return parent_name + "_" + scene_name

func show_chat():
	parent_name = get_parent().name
	if parent_name == "Affogato":
		convo_file = _get_complex_convo()
		music_file = parent_name.to_lower()
	else:
		convo_file = parent_name.replace(" ", "_")
		music_file = convo_file.to_lower()
	
	active = true
	if chat_with:
		chat_with.hide_after = false
		chat_with.visible = true
		chat_with.name_label.text = parent_name

func hide_chat():
	if chat_with:
		chat_with.visible = false
		chat_with.stop()
	active = false

func _on_body_entered(body):
	if body.name == "Player" and not disabled:
		show_chat()

func _on_body_exited(body):
	if body.name == "Player":
		hide_chat()
		player.enable()
		if nft_possible:
			nft.main.visible = false
			chat_with.visible = false

func _process(delta):
	if disabled and active:
		hide_chat()
		player.enable()
	if active and "idle" in get_parent():
		if chat_with.started:
			get_parent().idle = true
		else:
			player.enable()
			get_parent().idle = false

	if nft_possible:
		nft.update(chat_with.started, nft_id)
	._process(delta)

func _input(_event):
	if active:
		if Input.is_action_just_pressed("interact"):
			player.disable()
			if not chat_with.started:
				_add_audio("NPC", music_file)
			chat_with.start(convo_file)
			if nft_possible:
				nft.reward(nft_id)
