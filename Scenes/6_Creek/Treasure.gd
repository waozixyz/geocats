extends Area2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")
onready var chat_with =  get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var login = get_tree().get_current_scene().get_node("CanvasLayer/Login")

var touching = false

func _ready():
	set_process_input(true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		touching = true
		interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false
		chat_with.visible = false
		login.visible = false
		logging_in = false

var waiting
var show_login
var logging_in
func _process(delta):
	if global.updating:
		waiting = true
	elif waiting and touching:
		var res_code = global.response_code
		var res = global.response
		if res_code == 0:
			chat_with.visible = true
			chat_with.start("server_noconnect", true, false)
		elif res_code == 422 or res_code == 401:
			player.disabled = true
			login.visible = true
			logging_in = true
		elif res_code == 200:
			if res.val and res.val > -1:
				if res.val == 0:
					chat_with.start("geochache_rewarded", true, false)
			else:
				if res.available:
					print("yes")
				else:
					chat_with.visible = true
					chat_with.start("geochache_noreward", true, false)

		waiting = false
	if logging_in and not login.visible:
		logging_in = false
		player.disabled = false
		_get_nft()

func _get_nft():
	global.get_nft("GeoCache")
		
func _input(_event):

	# when i press the interact key (e)
	if interact_with.visible and not login.visible and touching and Input.is_action_just_pressed("interact"):
		_get_nft()
		interact_with.visible = false
		#chat_with.visible = true
		#chat_with.start("wip_geocache", true)
