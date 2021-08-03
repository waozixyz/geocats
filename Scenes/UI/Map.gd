extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	var unlocked = global.data.nav_unlocked
	var nv = global.data.nav_visible
	for child in get_node("Device").get_children():
		var unlock = child.get_node("Unlock")
		var lock = child.get_node("Lock")
		var map = child.get_node("Map")
		var label = child.get_node("Label")
		map.visible = false
		label.visible = false
		unlock.visible = false
		lock.visible = true
		for key in unlocked:
			if key == child.name:
				unlock.visible = true
				lock.visible = false
				print("hi")
		for key in nv:
			if key == child.name:
				unlock.visible = false
				map.visible = true
				label.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
