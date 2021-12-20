extends CanvasLayer

onready var control = $Control
onready var entry_container = $Control/Entries/ScrollContainer/VBoxContainer
onready var tab_label = $Control/Category/Label
onready var entry_template = entry_container.get_node("EntryTemplate")

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
	request = API.get_request("/get-nfts")
	_update_tab()

var exit
func _process(delta):
	if exit:
		if control.modulate.a > 0:
			control.modulate.a -= delta
		else:
			get_parent().remove_child(self)
			exit = false
	elif control.modulate.a < 1:
		control.modulate.a += delta

	if request:
		var data_size = request.get_downloaded_bytes()
		if data_size > 0 and API.response:
			_check_response(API.response)
			API.remove_child(request)
			request = null

var geocats = {}
func _update_nfts(remote_data):
	for remote_nft in remote_data:
		if remote_nft.has('ipfs_data_json'):
			var n = parse_json(remote_nft['ipfs_data_json'])
			for id in dex_data:
				var dex = dex_data[id]
				if dex.type.to_lower() == n['Type'].to_lower():
					var title = n['Title'].split(',')[0]
					dex.data[title] = {}
					var nft = dex.data[title]
					nft['description'] = n['Description']
					if n.has('edition'):
						if nft.has('edition'):
							nft['edition'].append(n['edition'])
						else:
							nft['edition'] = [n['edition']]

func _update_entries():
	var dex = dex_data[current_tab]
	for nft in dex.data:
		print(nft)
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

	
func _on_Exit_pressed():
	exit = true

func _input(event):
	if event.is_action_pressed("escape"):
		exit = true


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
