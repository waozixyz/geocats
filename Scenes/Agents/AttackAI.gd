extends MovingBody

var follow_player
export(float) var vision_x = 400
export(float) var vision_y = 300
export(float) var max_speed = 400
export(float) var acceleration = 10
export(float) var jump_timeout = 4
onready var player = get_tree().get_current_scene().player
var avg_x_dist_log = []
var avg_x_dist_index = 0
var jump_timer

func _ready():
	jump_timer = Timer.new()
	jump_timer.wait_time = jump_timeout
	jump_timer.one_shot = true
	add_child(jump_timer)
func _process(delta):
	if abs(player.position.x - position.x) < vision_x and abs(player.position.y - position.y) < vision_y:
		follow_player = true
	else:
		follow_player = false

	if follow_player:
		# change velocity x
		if player.position.x > position.x:
			if velocity.x < max_speed:
				velocity.x += acceleration
		elif player.position.x < position.x:
			if velocity.x > -max_speed:
				velocity.x -= acceleration
		# log x dist
		if avg_x_dist_log.size() < 10:
			avg_x_dist_log.append(player.position.x - position.x)
		else:
			avg_x_dist_log[avg_x_dist_index] = player.position.x - position.x
			avg_x_dist_index += 1
			if avg_x_dist_index >= avg_x_dist_log.size():
				avg_x_dist_index = 0
		# change velocity y
		if player.position.y < position.y and is_on_floor() and jump_timer.time_left == 0:
			jump(jump_height)
			jump_timer.start()
		if player.position.y > position.y + jump_height :
			fall_through()
	else:
		velocity.x = 0
	
	
	var avg_x_dist = 0
	if avg_x_dist_log.size() > 0:
		for avg_x in avg_x_dist_log:
			avg_x_dist += avg_x
		avg_x_dist /= avg_x_dist_log.size()

	if abs(velocity.x) > 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	sprite.flip_h = false if velocity.x > 0 else true
	
