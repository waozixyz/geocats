extends Node2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var below_player = $BehindPlayer
onready var above_player = $FrontPlayer
onready var giant_pumpkin = $GiantPumpkin

var theme = "CreepyCity"
var theme_path = "res://Assets/Levels/3_GeoCity/" + theme + "/"

func _ready():
	giant_pumpkin.visible = true


func creepy_city(): #Change to Pumpkin function which is called by collision
	if has_node(theme):
		theme.visible = true
	below_player.get_node("City_Buildings").texture = load(theme_path + "bg.png")
	below_player.get_node("City_BG").texture = load(theme_path + "red_sky.png")
	get_node("Salty_Swing").stop()
	get_node("Creepy_Swing").play()

func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport_geolodge")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport_geolodge"] = false
		SceneChanger.change_scene("GeoLodge", 0, "WayoWayo", 1)
