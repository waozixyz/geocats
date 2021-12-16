extends KinematicBody2D
class_name MovingBody

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

onready var sprite = $AnimatedSprite

# variables for all entities
var no_rotate = false
var velocity : Vector2 = Vector2.ZERO
# one way collding platform
var current_platforms = []
var disabled_platforms = []
# fall through platform
var fall_through_timer = 0
var fall_through_time = 30
# jump height
var jump_height = 100

func fall_through():
	for platform in current_platforms:
		platform.disabled = true

		disabled_platforms.insert(disabled_platforms.size(), platform)
	fall_through_timer =  OS.get_ticks_msec() * 0.001 + fall_through_time

func check_child_collision(child):
	if (child is CollisionShape2D || child is CollisionPolygon2D) && child.is_one_way_collision_enabled():
		return true
	else:
		return false


func apply_gravity (_delta: float):
	velocity.y += gravity

# ladder variables
var on_ladder : bool = false
var ladder_x : float
var ladder_y : float
var ladder_rot : float
var ladder_tween : Tween
# tween to ladder function
func tween_to_ladder():
	var new_x = ladder_x
	if ladder_rot != 0:
		var diff_y = position.y / ladder_y
		new_x = ladder_x - 25 *  (diff_y - 1) * ladder_rot

	var target = Vector2(new_x, position.y)
	
	# warning-ignore:return_value_discarded
	ladder_tween.interpolate_property(self, "position", position, target, 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	ladder_tween.start()

func _ready():
	# add ladder tween
	ladder_tween = Tween.new()
	add_child(ladder_tween)
	randomize()
	
func _stop_playing(stream):
	remove_child(stream)

	
func jump(jumpHeight):
	velocity.y = 0 #reset velocity
	velocity.y = -sqrt(50 * gravity * jumpHeight) 
	
var new_rot : float
var mushroom
func _physics_process(delta):
	if mushroom and mushroom.touching:
		mushroom.touching = false

	var rot = sprite.rotation
	if fall_through_timer >  OS.get_ticks_msec() * 0.001:
		fall_through_timer -= 1
	else:
		for platform in disabled_platforms:
			platform.disabled = false
		disabled_platforms = []
	current_platforms = []
	var slide_count = get_slide_count()
	if slide_count > 0:
		new_rot = 0
		for i in slide_count:
			var collision = get_slide_collision(i)
			if is_on_floor():
				for child in collision.collider.get_children():
					if check_child_collision(child):
						current_platforms.insert(current_platforms.size(), child)
					if child.get_parent().is_in_group("mushroom"):
						mushroom = child.get_parent()
						mushroom.touching = true
						jump(jump_height * mushroom.jump_multiplier)

			var normal = collision.normal

			if normal.x > -.7 && normal.x < .7 and normal.y < .7:
				var slope_angle = normal.dot(Vector2(0,-1)) - 1
				var mul = 1
				if normal.x < 0:
					mul = -1
				new_rot += -slope_angle * 4 * mul
			else:
				new_rot = rot * .5
	else:
		slide_count = 1
		new_rot = rot * .5

	if rot != new_rot:
		rot = (new_rot / slide_count + rot * 3) / 4
	if not no_rotate:
		sprite.rotation = rot
	apply_gravity(delta)
