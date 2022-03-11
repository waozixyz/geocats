extends Node2D

onready var spotlight = $Spotlight
onready var territories = $Territories
onready var chat = $Chat
onready var question = $Chat/Question
onready var exclaim = $Chat/Exclaim

var filter_out = ["Battle", "JokeRoom", "CavityPuzzleRoom", "GeoCacheRoom", "GreenCave", "PopNnip", "DonutShop"]

func _ready():
	for territory in territories.get_children():
		var err = territory.connect("input_event", self, "_input_event", [territory])
		assert(err == OK)

var last_territory = ""
var clicked_territory = false
var tween 

func label_clicked(do_something):
	print(do_something)
	
func _update_question(territory):
	exclaim.visible = false
	var label = question.get_node("RichTextLabel")
	label.bbcode_text = "Welcome to " + territory + " "

	for t in Territory.get_scenes(Territory.Names.keys().find(territory)):
		if filter_out.find(t) == -1:
			label.append_bbcode("Travel to [color=blue][url=" + t + "]" + t  + "[/url] [/color]")
			label.connect("meta_clicked", self, "label_clicked") 

func _update_spotlight(pos):
	spotlight.position = pos
	spotlight.visible = true
func _input_event( viewport, event, shape_idx, territory):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if territory.name != "Null":
			if last_territory != territory.name:
				if chat.modulate.a == 0:
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
		
