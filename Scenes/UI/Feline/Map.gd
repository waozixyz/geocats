extends Node2D

onready var spotlight = $SpotLight
onready var territories = $Territories
onready var chat = $Chat
onready var question = $Chat/Question
onready var exclaim = $Chat/Exclaim
	
func _ready():
	for territory in territories.get_children():
		var err = territory.connect("input_event", self, "_input_event", [territory])
		assert(err == OK)

var last_territory = ""
var clicked_territory = false
var tween 
func _input_event( viewport, event, shape_idx, territory):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if last_territory != territory.name:
			if chat.modulate.a == 0:
				utils.tween_fade(chat, 0, 1)
			question.get_node("RichTextLabel").text = territory.name
			#else:
			#	tween = utils.tween_fade(chat, 1, 0, 0.1)
				
		clicked_territory = true
		question.visible = true
		exclaim.visible = false
		last_territory = territory.name
func _input(event):
	if event is InputEventMouse and event.is_pressed() and event.button_index == BUTTON_LEFT:
		spotlight.position = event.position
		spotlight.visible = true
		clicked_territory = false
func _process(_delta):
	if tween and not tween.is_active():
		tween = null
		if not last_territory.empty():
			utils.tween_fade(chat, 0, 1)
			question.get_node("RichTextLabel").text = last_territory
	if not clicked_territory and not last_territory.empty():
		tween = utils.tween_fade(chat, 1, 0, 0.1)
		last_territory = ""
		
