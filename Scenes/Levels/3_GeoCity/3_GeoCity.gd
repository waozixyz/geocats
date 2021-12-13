extends Node2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var below_player = $BehindPlayer
onready var above_player = $FrontPlayer
onready var giant_pumpkin = $GiantPumpkin

var res_path = "res://Assets/Levels/3_GeoCity/"
func _ready():
	giant_pumpkin.visible = false
	set_theme("SnowyCity")


func set_theme(theme): #Change to Pumpkin function which is called by collision
	if has_node("BehindPlayer/" + theme):
		get_node("BehindPlayer/" + theme).visible = true
	if has_node("AbovePlayer/" + theme):
		get_node("AbovePlayer/" + theme).visible = true

	below_player.get_node("City_Buildings").texture = load(res_path + theme + "/bg.png")
	below_player.get_node("City_BG").texture = load(res_path + theme + "/sky.png")
	
	for child in get_node("Music").get_children():
		if child.name != theme:
			child.stop()
		else:
			child.play()
func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport_geolodge")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport_geolodge"] = false
		SceneChanger.change_scene("GeoLodge", 0, "WayoWayo", 1)
