extends InteractSimple

onready var camera = get_tree().get_current_scene().get_node("Default/Player/Camera2D")

var zoom_out : bool = false
var zoom_org : float = 0.0

func _ready():
	zoom_org = camera.zoom.x
	
func _zoomi(dir = 1):
	camera.zoom.x += 0.1 * dir
	camera.zoom.y += 0.1 * dir 
	camera.position.x += -6 * dir
func _process(delta):
	._process(delta)
	if touching:
		if do_something:
			player.disable("telescope")
			if camera.zoom.x <= zoom_org:
				zoom_out = true
			if camera.zoom.x > zoom_org:
				zoom_out = false
			do_something = false
					
		if zoom_out:
			if camera.zoom.x < 9.3:
				object.visible = false
				_zoomi()
			else:
				object.visible = true
		else:
			if camera.zoom.x > zoom_org:
				_zoomi(-1)
			else:
				object.visible = true
				player.enable("telescope")

