extends CanvasLayer

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().get_node("Default/Player")

onready var login = $Login
onready var main = $Main
onready var received_nft = $Main/Taskbar/Received
onready var nft_name = $Main/Name
onready var description = $Main/Description
onready var exit_button = $Main/Taskbar/Exit
onready var image_panel = $Main/ImagePanel

onready var type_value = $Main/Type/Value
onready var edition_value = $Main/Edition/Value
onready var location_panel = $Main/Location

onready var loading = $Loading

var waiting
var show_login
var reward_available: bool = false
var anim

func _ready():
	exit_button.connect("pressed", self, "_exit_pressed")

func _exit_pressed():
	main.visible = false
	login.visible = false

func show_nft(nft_id, nft, new = false):
	main.visible = true
	received_nft.visible = new
	nft_name.text = nft['Title']
	description.text = nft['Description']
	var new_anim = load("res://Scenes/UI/NFT/Anim/" + nft_id + ".tscn")
	anim = new_anim.instance()
	anim.play(nft['Title'])
	image_panel.add_child(anim)
	
	# show location panel
	if nft.has('Location'):
		location_panel.visible = true
		location_panel.get_node('Value').text = nft['Location']
	elif nft.has('id'):
		location_panel.visible = true
		location_panel.get_node('Value').text = nft['id']
	else:
		location_panel.visibel = false
	
	edition_value.text = str(nft["edition"])
	type_value.text = nft["Type"]

var loading_ticker = 0
func update(delta, touching, nft_id):
	if global.updating == "nft":
		loading_ticker += delta
		if loading_ticker > 20:
			loading.visible = true
		waiting = true
	elif waiting and touching:
		loading_ticker = 0
		loading.visible = false
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
					if res.available:
						global.nft_api("/claim", nft_id)
					else:
						if res.nft:
							show_nft(nft_id, res.nft)
						elif res.claimed:
							chat_with.start("geochache_rewarded", true, false)
						else:
							chat_with.start("geochache_noreward", true, false)

				elif res.process == "check-wallet":
					if res.status:
						if res.val > 0:
							pass
						#	show_nft(nft_id, res.title, res.description, false)
						elif reward_available:
							global.geoserver("/claim", nft_id)
						else:
							chat_with.start("geochache_noreward", true, false)
					else:
						login.visible = true
				elif res.process == "check":
					if res.name == "GeoKey":
						login.visible = false

						global.nft_api("/check-wallet", nft_id)
				elif res.process == "get-nft":
					if res.val:
						if not res.has("title"):
							res['title'] = nft_id

						if res.status:
							pass
						#	show_nft(nft_id, res.title, res.description, true)
						else:
							pass
						#	show_nft(nft_id, res.title, res.description, false)
					else:
						global.nft_api("/available", nft_id)
				else:
					printerr("something wrong with nft logic")
		waiting = false
	else:
		loading.visible = false
	if login.visible or loading.visible:
		player.disable()
	else:
		player.enable()

func reward(nft_id):
	global.nft_api("/available", nft_id)
	
func _input(event):
	if event.is_action_pressed("escape"):
		main.visible = false
		login.visible = false
	if main.visible and event.is_action_pressed("interact"):
		main.visible = false
