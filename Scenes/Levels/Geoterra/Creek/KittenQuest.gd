extends Area2D

onready var current_scene = get_tree().get_current_scene()

onready var garloo_kitten = $Garloo
onready var collision_shape = $CollisionShape2D
onready var teacher_bot = $Teacherbot
onready var waypoint_1 = $Waypoint1

var lost_kittens = ["Garloo", "Daisy", "Caramel", "Sandy", "Sparkle", "Lethe"]
var found_kittens = []
var new_kittens = []

var left_bound = 0
var right_bound = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if PROGRESS.variables.has("geoterra_kitten_found_them") and PROGRESS.variables["geoterra_kitten_found_them"]:
		visible = false
		for child in get_children():
			remove_child(child)
	left_bound = collision_shape.position.x - collision_shape.shape.extents.x
	right_bound = collision_shape.position.x + collision_shape.shape.extents.x
	for child in global.user.following:
		var node = get_node_or_null(child)
		if node:
			remove_child(node)
	for child in get_children():
		if lost_kittens.has(child.name) and left_bound < child.position.x and right_bound > child.position.x and child.visible:
			found_kittens.append(child)



	if not is_connected("body_entered", self, "_on_body_entered"):
		var err = connect("body_entered", self, "_on_body_entered")
		assert(err == OK) 

	
func _on_body_entered(body):
	if lost_kittens.has(body.name) and not found_kittens.has(body.name):
		new_kittens.append(body)
		current_scene.remove_follower(body, false)

var mv_peed = 200
var current_waypoint = 1

func next_waypoint(kitten, fall = false): 
	if kitten == teacher_bot:
		if fall:
			for child in get_children():
				if child is KinematicBody2D:
					child.fall_through(true)
		if current_waypoint < 3:
			current_waypoint += 1

func _process(_delta):
	if PROGRESS.variables.has("geoterra_kitten_found_them") and PROGRESS.variables["geoterra_kitten_found_them"]:

		for kitten in get_children():
			if kitten is KinematicBody2D:
				var lb = waypoint_1.position.x - mv_peed
				var rb =  waypoint_1.position.x + mv_peed
				if kitten.position.x > lb:
					kitten.velocity.x = -mv_peed
					if kitten == teacher_bot:
						current_scene.set_disable("player", "animation_teacher")
				if kitten.position.x < rb:
					remove_child(kitten)
					if kitten == teacher_bot:
						current_scene.set_disable("player", "animation_teacher", false)

	if found_kittens.size() == 6:
		PROGRESS.quests["geoterra_kitten_quest_complete"] = true
	
	if PROGRESS.variables.has("geoterra_garloo_follow") and PROGRESS.variables["geoterra_garloo_follow"]:
		PROGRESS.variables["geoterra_garloo_follow"] = false
		current_scene.add_follower(garloo_kitten, true)

	if PROGRESS.variables.has("geoterra_sparkle_follow") and PROGRESS.variables["geoterra_sparkle_follow"]:
		PROGRESS.variables["geoterra_garloo_follow"] = false
		current_scene.add_follower(garloo_kitten, true)

	for kitten in new_kittens:
		var dest = get_node_or_null(kitten.name + "2")

		if abs(kitten.position.x - dest.position.x) < 10 and abs(kitten.position.y - dest.position.y) < 10 :
			dest.visible = true
			new_kittens.erase(kitten)
			found_kittens.append(kitten)
			current_scene.remove_child(kitten)

		else:
			if kitten.position.x < dest.position.x:
				kitten.velocity.x = mv_peed
			elif kitten.position.x > dest.position.x:
				kitten.velocity.x = -mv_peed
	for kitten in found_kittens:
		if kitten.position.x > 6975:
			kitten.velocity.x -= 20
		if kitten.position.x < left_bound:
			kitten.velocity.x += 20


