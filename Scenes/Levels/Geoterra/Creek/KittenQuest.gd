extends Area2D

onready var current_scene = get_tree().get_current_scene()
onready var lethe_position = $Lethe

var lost_kittens = ["Garloo", "Daisy", "Caramel", "Sandy", "Sparkle", "Lethe"]
var found_kittens = []
var new_kittens = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is MovingBody:
			if lost_kittens.has(child.name):
				found_kittens.append(child.name)

	print(found_kittens)
	if not is_connected("body_entered", self, "_on_body_entered"):
		var err = connect("body_entered", self, "_on_body_entered")
		assert(err == OK) 
	if not is_connected("body_exited", self, "_on_body_exited"):
		var err = connect("body_exited", self, "_on_body_exited")
		assert(err == OK) 
	
func _on_body_entered(body):
	if lost_kittens.has(body.name):
		new_kittens.append(body)
		current_scene.remove_follower(body, false)

var mv_peed = 200
func _process(delta):
	for kitten in new_kittens:
		var dest = get_node(kitten.name)
		var dest_pos = dest.position + position
		if abs(kitten.position.x - dest_pos.x) < 10:
			dest.visible = true
			new_kittens.erase(kitten)
			found_kittens.append(kitten.name)
			current_scene.remove_child(kitten)

		else:
			if kitten.position.x < dest_pos.x:
				kitten.velocity.x = mv_peed
			elif kitten.position.x > dest_pos.x:
				kitten.velocity.x = -mv_peed

func _on_body_exited(body):
	if lost_kittens.has(body.name):
		found_kittens.remove(body.name)
