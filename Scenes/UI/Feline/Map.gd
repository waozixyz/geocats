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

var filter_out = ["Battle", "JokeRoom", "CavityPuzzleRoom", "GeoCacheRoom", "GreenCave", "PopNnip", "DonutShop"]

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
	SceneChanger.change_scene(utils.find_level_path(data[0], data[1]))
	
func _update_question(territory):
	exclaim.visible = false
	var label = question.get_node("RichTextLabel")
	label.bbcode_text = "[center] Welcome to " + territory + "[/center]"
	label.newline()
	label.newline()
	for t in Territory.get_scenes(Territory.Names.keys().find(territory)):
		if filter_out.find(t) == -1:
			label.append_bbcode("Travel to [color=blue][url=" + territory + ", " + t + "]" + t  + "[/url][/color]")
			label.newline()
			label.connect("meta_clicked", self, "label_clicked") 

func _update_spotlight(pos):
	spotlight.position = pos
	spotlight.visible = true
func _input_event( viewport, event, shape_idx, territory):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if territory.name != "Null":
			if last_territory != territory.name and chat.modulate.a == 0:
				utils.tween_fade(chat, 0, 1)
			_update_question(territory.name)
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
			_update_question(last_territory)
	if not clicked_territory and not last_territory.empty():
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
