extends Node2D

onready var ringmap = $Ringmap
onready var spotlight = $Spotlight
onready var territories = $Ringmap/Territories
onready var chat = $Chat
onready var question = $Chat/Question
onready var exclaim = $Chat/Exclaim
onready var arrow_left = $Controls/ArrowLeft
onready var arrow_right = $Controls/ArrowRight

var scroll_speed = 8

var filter_out = ["Arcade", "Battle", "JokeRoom", "CatsCradle", "CavityPuzzleRoom", "GeoCacheRoom", "GreenCave", "PopNnip", "DonutShop"]

func _replace_scene_name(scene_name):
	match scene_name:
		"CatsCradle": return "Cat's Cradel"
		"Complex": return "NONACO Housing Project #420"
		"Creek": return "Canopy Creek"
		"Arcade": return "Geistesfluch Arcade"
		_: return scene_name

func _ready():
	for territory in territories.get_children():
		var err = territory.connect("input_event", self, "_input_event", [territory])
		assert(err == OK)
	chat.modulate.a = 0
var last_territory = ""
var clicked_territory = false
var tween 

func label_clicked(data):
	data = data.split(', ')
	global.user.location = 0
	SceneChanger.change_scene(data[0], data[1])
	
func _update_dialogue(territory):
	if global.user.visited.has(territory):
		exclaim.visible = true
		question.visible = false
		var label = exclaim.get_node("RichTextLabel")
		label.bbcode_text = "[center] Welcome to " + territory + "[/center]"
		label.newline()
		label.newline()
		var count = 0
		for t in Territory.get_scenes(Territory.Names.keys().find(territory)):
			# if the scene name is not in the filter out list, continue
			var opt = filter_out.find(t)
			if opt == -1:
				# if the scene name has been visited, continue
				opt = global.user.visited[territory].find(t)
				if opt != -1:
					label.append_bbcode("[center] Travel to [/center]")
					label.newline()
					label.append_bbcode("[center][color=blue][url=" + territory + ", " + t + "]" + _replace_scene_name(t)  + "[/url][/color][/center]")
					label.newline()
					label.newline()
					label.connect("meta_clicked", self, "label_clicked")
					count += 1
		if count == 0:
			label.append_bbcode("Sorry, travel here is currently unavailable")

	else:
		exclaim.visible = false
		question.visible = true
		
		var label = question.get_node("RichTextLabel")
		label.bbcode_text = "Sorry, but it seems like travel to this area is currently unavailable."
func _update_spotlight(pos):
	spotlight.position = pos
	spotlight.visible = true
func _input_event( viewport, event, shape_idx, territory):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if territory.name != "Null":
			if last_territory != territory.name and chat.modulate.a == 0:
				utils.tween_fade(chat, 0, 1)
			_update_dialogue(territory.name)
			clicked_territory = true
			last_territory = territory.name
		else:
			clicked_territory = false

		_update_spotlight(event.position)
	


func _process(_delta):
	if tween and not tween.is_active():
		tween = null
		if not last_territory.empty():
			utils.tween_fade(chat, 0, 1)
			_update_dialogue(last_territory)
	if not clicked_territory and not last_territory.empty():
		if chat.modulate.a != 0:
			tween = utils.tween_fade(chat, 1, 0, 0.1)
		last_territory = ""
		
	if arrow_right.pressed:
		if ringmap.position.x > -ringmap.texture.get_width() * ringmap.scale.x + 650:
			ringmap.position.x -= scroll_speed
		spotlight.visible = false
		clicked_territory = false
	if arrow_left.pressed:
		if ringmap.position.x < 0:
			ringmap.position.x += scroll_speed
		spotlight.visible = false
		clicked_territory = false
