extends CanvasLayer

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().get_node("Default/Player")

onready var login = $Login
onready var main = $Main
onready var received_nft = $Main/Taskbar/Received
onready var nft_name = $Main/Name
onready var description = $Main/Description
onready var exit_button = $Main/Taskbar/Exit

var waiting
var show_login
var reward_available: bool = false
var anim

func _ready():
	exit_button.connect("pressed", self, "_exit_pressed")

func _exit_pressed():
	main.visible = false
	login.visible = false
func show_nft(nft_id,  edition, nft_title, nft_description, new = false):
	main.visible = true
	received_nft.visible = new
	nft_name.text = nft_title
	description.text = nft_description
	var new_anim = load("res://Scenes/UI/NFT/Anim/" + nft_id + ".tscn")
	anim = new_anim.instance()
	anim.play(str(edition))
	main.add_child(anim)
	
func update(touching, nft_id):
	if global.updating:
		waiting = true
	elif waiting and touching:
		var res_code = global.response_code
		var res = global.response
		if res_code == 0:
			chat_with.visible = true
			chat_with.start("server_noconnect", true, false)
		elif res_code == 422 or res_code == 401:
				login.visible = true
		else:
			if res and res.has("process"):
				if res.process == "available":
					if res.count > 0:
						reward_available = true
					else:
						reward_available = false
					global.nft_api("/check-wallet", nft_id)
				elif res.process == "check-wallet":
					if res.status:
						if res.val > 0:
							show_nft(nft_id, res.val, res.title, res.description, false)
						elif reward_available:
							global.nft_api("/get", nft_id)
						else:
							chat_with.start("geochache_noreward", true, false)
					else:
						login.visible = true
				elif res.process == "check":
					if res.name == "GeoKey":
						login.visible = false

						global.nft_api("/check-wallet", nft_id)
				elif res.process == "get-nft":
					if res.val > 0:
						if res.status:
							show_nft(nft_id, res.val, res.title, res.description, true)
						else:
							show_nft(nft_id, res.val, res.title, res.description, false)
					else:
						global.nft_api("/available", nft_id)
				else:
					print("something wrong")
		waiting = false
	if login.visible:
		player.disabled = true
	else:
		player.disabled = false
#			
#
#			elif res_code == 200:
#				if res.has("val"):
#					if res.val > -1:
#						if res.val == 0:
#							chat_with.start("geochache_rewarded", true, false)
#						else:
#							#geocache.visible = true
#							if res.status:
#								received_nft.visible = true
#							#else:
#							#	current_nft.visible = true
#					else:
#						chat_with.visible = true
#						chat_with.start("geochache_noreward", true, false)

	#	reward(nft_id)


func reward(nft_id):
	global.nft_api("/available", nft_id)
	
func _input(event):
	if event.is_action_pressed("escape"):
		main.visible = false
		login.visible = false
	if main.visible and event.is_action_pressed("interact"):
		main.visible = false
