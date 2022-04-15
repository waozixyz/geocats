extends GeneralLevel

onready var behind_player = get_node_or_null("BehindPlayer")
onready var above_player = get_node_or_null("AbovePlayer")
onready var giant_pumpkin = $GiantPumpkin

var res_path = "res://Assets/Levels/GeoCity/GeoCity/"

func _ready():
	AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
	AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
	#var season = utils.get_season()
	var season = "Summer"
	if season == "Winter":
		set_theme("SnowyCity")
	elif season  == "Autumn":
		# giant_pumpkin.visible = true
		set_theme("DefaultCity")
	else:
		set_theme("DefaultCity")

func set_theme(theme): #Change to Pumpkin function which is called by collision
	for child in behind_player.get_children():
		if child.get_child_count() > 0 and child is Node2D:
			if child.name == theme:
				child.visible = true
			else:
				behind_player.remove_child(child)
	for child in above_player.get_children():
		if child.get_child_count() > 0 and child is Node2D:
			if child.name == theme:
				child.visible = true
			else:
				above_player.remove_child(child)
	var file2Check = File.new()
	if file2Check.file_exists(res_path + theme + "/buildings.png"):
		behind_player.get_node("Buildings").texture = load(res_path + theme + "/buildings.png")
	if file2Check.file_exists(res_path + theme + "/sky.png"):
		behind_player.get_node("Sky").texture = load(res_path + theme + "/sky.png")

	if file2Check.file_exists(res_path + theme + "/buildings.png"):
		behind_player.get_node("Buildings").texture = load(res_path + theme + "/buildings.png")
	if file2Check.file_exists(res_path + theme + "/sky.png"):
		behind_player.get_node("Sky").texture = load(res_path + theme + "/sky.png")


	for child in get_node("Music").get_children():
		if child.name != theme:
			child.stop()
		else:
			child.play()

func _physics_process(_delta):
	var teleport = PROGRESS.variables.get("teleport_geolodge")
	if teleport:
		PROGRESS.variables["teleport_geolodge"] = false
		AudioManager.play_sound(utils.get_teleport_sound("WayoWayo"))
		SceneChanger.change_scene("Glaciokarst", "GeoLodge")

