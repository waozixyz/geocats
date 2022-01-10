extends CanvasLayer

onready var control = $Control
onready var entry_container = $Control/Entries/ScrollContainer/VBoxContainer
onready var tab_label = $Control/Category/Label
onready var entry_template = $Control/EntryTemplate
onready var info_label = $Control/InfoPanel/RichTextLabel
onready var current_editions = $Control/CurrentEditions
onready var edition_label = $Control/EditionLabel
onready var image_empty_cat = $Control/ImageButton/Cat
onready var image_container = $Control/ImageButton/Container
onready var image_button = $Control/ImageButton

var current_tab = 0
var dex_data = {
	0: {
		"type": "Geocat",
		"data": {}
	},
	1: {
		"type": "Geotreasure",
		"data": {}
	},
	2: {
		"type": "Geopixel",
		"data": {}
	},
	3: {
		"type": "Geocel",
		"data": {}
	}
}

var request: HTTPRequest
func _ready():
	control.modulate.a = 0
	_update_tab()
	_request_geodex()
var exit
var repeat_request

func _request_geodex():
	request = API.get_request("/get-nfts")
	
func _process(delta):
	if exit:
		if control.modulate.a > 0:
			control.modulate.a -= delta
		else:
			get_parent().remove_child(self)
			exit = false
	elif control.modulate.a < 1:
		control.modulate.a += delta
		

	if not API.refreshing and request and not repeat_request:
		var data_size = request.get_downloaded_bytes()
		if data_size > 0 and API.response and request.get_http_client_status() == 0:
			_check_response(API.response)
			API.remove_child(request)
			request = null
	if repeat_request:
		_request_geodex()
		repeat_request = false
var geocats = {}
func _update_nfts(remote_data):
	for remote_nft in remote_data:
		if remote_nft.has('ipfs_data_json'):
			var n = parse_json(remote_nft['ipfs_data_json'])
			for id in dex_data:
				var dex = dex_data[id]
				if n.has('Type'):
					if dex.type.to_lower() == n['Type'].to_lower() or dex.type == "Geotreasure" and n['Type'] == "Geomonster":
						var title = n['Title']
						if not dex.data.has(title):
							dex.data[title] = {}
						var nft = dex.data[title]
						nft['description'] = n['Description']

						if n.has('edition'):
							var ed = n['edition']
							if not nft.has('edition'):
								nft['edition'] = {}
							
							if nft['edition'].has(ed):
								nft['edition'][ed] += 1
							else:
								nft['edition'][ed] = 1
				else:
					printerr('no type field found: ', n)
func _update_entries():
	# clear entry container
	for n in entry_container.get_children():
		entry_container.remove_child(n)
		n.queue_free()
	_clear_content()
	# load new entries
	var dex = dex_data[current_tab]
	for nft in dex.data:
		var entry = entry_template.duplicate()
		entry.visible = true
		var entry_label = entry.get_node('Label')
		entry_label.text = nft
		entry_container.add_child(entry)
		
func _check_response(res):
	# api set location finished
	if res.has('data'):
		var data = res['data']
		if data:
			_update_nfts(data)
			_update_entries()
		else:
			# no nfts present
			pass
	else:
		printerr('no data received for geodex')
		repeat_request = true

	
func _on_Exit_pressed():
	exit = true

func _input(event):
	if event.is_action_pressed("escape"):
		exit = true
func _clear_content():
	# clear image container
	for n in image_container.get_children():
		image_container.remove_child(n)
		n.queue_free()
	
	# clear description
	info_label.text = ""
	# clear editions
	edition_label.visible = false
	current_editions.text = ""
	image_empty_cat.visible = true

func _get_filename(title):
	title = title.to_lower()
	for chr in ["#", ".", ",", "- ", "'"]:
		title = title.replace(chr, '')
	return title.replace(" ", "_").replace("&", "and")

var active_title
func activate_entry(title):
	active_title = title
	var current_dex = dex_data[current_tab]
	var current_nft = current_dex.data[title]
	_clear_content()
	# update description
	info_label.text = current_nft.description
	# update editions
	if current_nft.has('edition'):
		edition_label.visible = true
		var editions = current_nft.edition
		for edition in editions:
			if current_editions.text != "":
				current_editions.text += ","
			
			current_editions.text += " " + str(edition)
			if editions[edition] > 1:
				current_editions.text += " (" + str(editions[edition]) + ")"
			
	# update image
	var file_name = _get_filename(title)
	var type = current_dex.type
	var file2Check = File.new()
	var file_path = "res://Assets/NFT/" + type + "/" + file_name
	var tres_exists = file2Check.file_exists(file_path + ".tres")
	var png_exists = file2Check.file_exists(file_path + ".png")
	var image
	var frame
	if tres_exists:
		var tres = load(file_path + ".tres")
		if tres is StreamTexture:
			image = Sprite.new()
			image.texture = tres
			frame = image.texture
		elif tres is SpriteFrames:
			image = AnimatedSprite.new()
			image.frames = load(file_path + ".tres")
			image.play("default")
			frame = image.frames.get_frame("default", 0)
		else:
			printerr("texture file broken: ", tres)

	elif png_exists:
		image = Sprite.new()
		image.texture = load(file_path + ".png")
		frame = image.texture
	else:
		# no resource found
		printerr("no image found for " + title)

	if image and frame:
		image_empty_cat.visible = false
		var w = frame.get_width()
		var h = frame.get_height()
		var size = w if h < w else h
		var sc = image_button.rect_size.y / (size * 1.2)
		image.scale = Vector2(sc, sc)
		image_container.add_child(image)


	
func _update_tab():
	tab_label.text = dex_data[current_tab].type + 's'
	_update_entries()

func _on_TabLeft_pressed():
	current_tab -= 1
	if current_tab < 0:
		current_tab = dex_data.size() - 1
	_update_tab()


func _on_TabRight_pressed():
	current_tab += 1
	if current_tab > dex_data.size() - 1:
		current_tab = 0
	_update_tab()


func _on_ImageButton_pressed():
	var current_dex = dex_data[current_tab]
	print(active_title)
	if current_dex.data.has(active_title):
		var current_nft = current_dex.data[active_title]
		print(current_nft)
	
