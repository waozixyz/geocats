extends Area2D

func _ready():
	var err = connect("body_entered", self, "_on_body_entered")
	assert(err == OK) 
	err = connect("body_exited", self, "_on_body_exited")
	assert(err == OK) 
	collision_layer = 7

func _is_valid(body):
	return body is MovingBody
	
func _on_body_entered(body):
	if _is_valid(body):
		body.on_ladder = true
		body.ladder_x = self.position.x
		body.ladder_y = self.position.y
		body.ladder_rot = self.rotation_degrees

			
func _on_body_exited(body):
	if _is_valid(body):
		body.on_ladder = false
