extends GeneralLevel

onready var stars = $BelowPlayer/Stars
onready var space_bg = $BelowPlayer/SpaceBG
onready var space_fg = $AbovePlayer/SpaceFG

var travel_speed = 20
var bg_scale = 5
var bg_width = 1500
var offset = Vector2(0,0)
func _process(delta):
	offset.x += travel_speed * delta
	stars.material.set_shader_param('global_transform', get_global_transform() )
	stars.material.set_shader_param('offset', offset * 2 )
	for child in space_bg.get_children():
		child.position.x -= travel_speed * delta
		if child.position.x < -bg_width * 0.5:
			child.position.x = bg_width
	for child in space_fg.get_children():
		child.position.x += travel_speed * delta
		if child.position.x > bg_width:
			child.position.x = -bg_width

