extends Node2D
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
func _physics_process(delta):
	var teleport = PROGRESS.variables.get("teleport")

	if teleport:
		chat_with.visible = false
		chat_with.stop()
		PROGRESS.variables["teleport"] = false
		SceneChanger.change_scene("Creek", 0, "WayoWayo", 1)


