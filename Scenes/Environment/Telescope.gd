extends E_Interact

export(Vector2) var dest_zoom = Vector2(2,2)
export(float) var zoom_speed = 1
export(Vector2) var offset = Vector2(0,0)

var org_zoom = Vector2(1, 1)
var org_offset = Vector2(0,0)

func _ready():
	org_zoom = camera.zoom
	org_offset = camera.offset
	
var tween_zoom
var tween_offset
var zoom_out = true
func _is_active():
	return tween_zoom and not tween_zoom.is_active() or not tween_zoom
	
func _process(delta):
	if do_something:
		current_scene.set_disable("player", disable_player)
		if camera.zoom != dest_zoom and _is_active():
			tween_zoom = utils.tween(camera, "zoom", dest_zoom, zoom_speed)
			tween_offset = utils.tween(camera, "offset", offset, zoom_speed * .5)
		else:
			var speed = zoom_speed
			if tween_zoom.is_active():
				speed = tween_zoom.tell()
				tween_zoom.remove_all()
				if tween_offset.is_active():
					tween_offset.remove_all()
				
			tween_zoom = utils.tween(camera, "zoom", org_zoom, speed)
			tween_offset = utils.tween(camera, "offset", org_offset, speed)
		do_something = false

	if _is_active() and camera.zoom == org_zoom:
		current_scene.set_disable("player", disable_player, false)
