extends CanvasLayer

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().player

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
var reward_available: bool = false
var anim

func _ready():
	exit_button.connect("pressed", self, "_exit_pressed")

func _exit_pressed():
	main.visible = false
	login.visible = false

func _show_nft(nft_id, nft, new = false):
	main.visible = true
	received_nft.visible = new
	nft_name.text = nft['Title']
	description.text = nft['Description']
	var file_name = nft_id.replace(" ", "") 
	var new_anim = load("res://Scenes/NFTs/Geocats/" + file_name + ".tscn")
	if new_anim:
		anim = new_anim.instance()
		anim.play(nft['Title'])
	else:
		anim = Sprite.new()
		anim.texture = load("res://Assets/NFTs/" + file_name + ".png")
		anim.scale = Vector2(10, 10)
	image_panel.add_child(anim)
	
	# show location panel
	if nft.has('Location'):
		location_panel.visible = true
		location_panel.get_node('Value').text = nft['Location']
	elif nft.has('id'):
		location_panel.visible = true
		location_panel.get_node('Value').text = nft['id']
	else:
		location_panel.visible = false
	
	edition_value.text = str(nft["edition"])
	type_value.text = nft["Type"]

func _nft_unavailable(nft_id, res):

	if res.nft:
		_show_nft(nft_id, res.nft)
	elif show_chat:
		if res.claimed:
			chat_with.start("geochache_rewarded", true, false)
		else:
			chat_with.start("geochache_noreward", true, false)
	nft_ids.erase(nft_id)
	active = false

var loading_ticker = 0
var show_chat = true
var active = false
var nft_ids = []
func _process(_delta):
	if request:
		var body_size = request.get_body_size()
		if body_size > 0:
			deta.remove_child(request)
			request = null
#	var res_code = deta.response_code
#	if res_code == 405:
#		login.visible = true
#	if nft_ids.size() > 0 and not active:
#		global.nft_api("/available", nft_ids[0])
#		active = true

#	var res = global.response
#	if res and res.has("process") and res['process'] == "logged_in":
#		waiting = true

#	if global.updating == "nft":
#		loading_ticker += delta
#		if loading_ticker > 4:
#			loading.visible = true
#		waiting = true
#	elif waiting and active and nft_ids.size() > 0:
#		var nft_id = nft_ids[0]
#
#		loading_ticker = 0
#		loading.visible = false
#
#		if res_code == 0:
#			if show_chat:
#				chat_with.visible = true
#				chat_with.start("server_noconnect", true, false)
#		else:
#			if res and res.has("process"):
#				if res.process == "available":
#					if res.available:
#						global.nft_api("/claim", nft_id)
#					else:
#						_nft_unavailable(nft_id, res)
#				elif res.process == "logged_in":
#					global.nft_api("/claim", nft_id)
#				elif res.process == "claiming_nft":
#					if res.available:
#						_show_nft(nft_id, res.nft, true)
#						nft_ids.erase(nft_id)
#						active = false
#					else:
#						_nft_unavailable(nft_id, res)
#				else:
#					nft_ids.erase(nft_id)
#					printerr("something wrong with nft logic")
#		waiting = false
#	else:
#		loading.visible = false
		
#	if login.visible or loading.visible:
#		player.disable("nft")
#	else:
#		player.enable("nft")
	pass
var request
func reward(nft_id, chat = true):
	request = deta.get_request("/claim-nft", {"nft-id": nft_id})
	show_chat = chat

	
func _input(event):
	if event.is_action_pressed("escape"):
		main.visible = false
		login.visible = false
	if main.visible and event.is_action_pressed("interact"):
		main.visible = false
