extends Node2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var below_player = $BehindPlayer
onready var above_player = $FrontPlayer
onready var giant_pumpkin = $GiantPumpkin

var theme = "GeoCity"
var res_path = "res://Assets/Levels/3_GeoCity/"
var last_theme = "GeoCity"
func _ready():
	get_tree().get_current_scene().theme = "SnowyCity"
	giant_pumpkin.visible = false


func set_theme(): #Change to Pumpkin function which is called by collision
	if has_node("BehindPlayer/" + theme):
		get_node("BehindPlayer/" + theme).visible = true
	if has_node("AbovePlayer/" + theme):
		get_node("AbovePlayer/" + theme).visible = true

	below_player.get_node("City_Buildings").texture = load(res_path + theme + "/bg.png")
	below_player.get_node("City_BG").texture = load(res_path + theme + "/red_sky.png")
	get_node("Music/Salty_Swing").stop()
	#get_node("Music/Creepy_Swing").play()
	get_node("Music/Snowy_Swing").play()
func _physics_process(delta):
	if PROGRESS.variables.get("NonacoPumpkinPuzzle"):
		theme = "CreepyCity"
	if theme != "GeoCity" and last_theme != theme:
		set_theme()
		last_theme = theme
	var teleport = PROGRESS.variables.get("teleport_geolodge")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport_geolodge"] = false
		SceneChanger.change_scene("GeoLodge", 0, "WayoWayo", 1)
