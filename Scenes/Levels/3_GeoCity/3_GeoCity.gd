extends Node2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var below_player = $BelowPlayer

var theme = "Creepy_City"
var theme_path = "res://Assets/Levels/3_GeoCity/" + theme + "/"

func _ready(): #Change to Pumpkin function which is called by collision
	below_player.get_node("City_Buildings").texture = load(theme_path + "bg.png")
	below_player.get_node("City_BG").texture = load(theme_path + "red_sky.png")

func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport_geolodge")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport_geolodge"] = false
		SceneChanger.change_scene("GeoLodge", 0, "WayoWayo", 1)
