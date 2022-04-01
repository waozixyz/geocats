extends KinematicBody2D
class_name MovingBody

onready var platform_raycast = $PlatformRaycast
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") setget ,_get_gravity

func _get_gravity():
	return ProjectSettings.get_setting("physics/2d/default_gravity")

onready var sprite = $AnimatedSprite

export(bool) var add_move_n_slide = false

# variables for all entities
var no_rotate = false
var no_gravity = false
export(bool) var mirror_sprite = false
var velocity : Vector2 = Vector2.ZERO
# one way collding platform

# fall through platform
var fall_through_timer
var allow_fall_trough_timer
# jump height
export var jump_height = 100

func fall_through(force = false):
	if allow_fall_trough_timer.time_left > 0 or force:
		set_collision_mask(0)
		fall_through_timer.start()



func check_child_collision(child):
	if (child is CollisionShape2D || child is CollisionPolygon2D) && child.is_one_way_collision_enabled():
		return true
	else:
		return false


func apply_gravity (factor: float = 1):
	velocity.y += gravity * factor

# ladder variables
var on_ladder : bool = false
var ladder_x : float
var ladder_y : float
var ladder_rot : float
var ladder_tween : Tween
var max_angle = 0.8
var layer_bit = 0
var allow_fall_through = false
var manage_anim = true
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
	layer_bit = collision_layer
	# add ladder tween
	ladder_tween = Tween.new()
	add_child(ladder_tween)
	randomize()
	allow_fall_trough_timer = Timer.new()
	fall_through_timer = Timer.new()
	add_child(allow_fall_trough_timer)
	add_child(fall_through_timer)
	fall_through_timer.wait_time = 0.2
	allow_fall_trough_timer.wait_time = 0.2
	fall_through_timer.one_shot = true
	allow_fall_trough_timer.one_shot = true

	
func _stop_playing(stream):
	remove_child(stream)

	
func jump(jumpHeight):
	velocity.y = 0 #reset velocity
	velocity.y = -sqrt(50 * gravity * jumpHeight) 
	
var new_rot : float
var mushroom
func _physics_process(_delta):

	if mushroom and mushroom.touching:
		mushroom.touching = false

	var rot = sprite.rotation
	if fall_through_timer.time_left == 0:
		set_collision_mask(layer_bit)


	var slide_count = get_slide_count()
	
	# set sprite direction
	if manage_anim:
		if velocity.x == 0:
			sprite.play("idle")
		elif sprite.frames.has_animation("walk"):
			sprite.play("walk")
			
	# check platofrms
	var platforms = []
	if slide_count > 0:
		new_rot = 0
		for i in slide_count:
			var collision = get_slide_collision(i)
			if is_on_floor():
				for child in collision.collider.get_children():
					if check_child_collision(child):
						platforms.append(child)
					if child.get_parent().is_in_group("mushroom"):
						mushroom = child.get_parent()
						mushroom.touching = true
						jump(jump_height * mushroom.jump_multiplier)

			var normal = collision.normal

			if normal.x > -max_angle && normal.x < max_angle and normal.y < max_angle:
				var slope_angle = normal.dot(Vector2(0,-1)) - 1
				new_rot += -slope_angle * 3 * normal.x
			else:
				new_rot = rot * .5
	else:
		slide_count = 1
		new_rot = rot * .5

	# fix rotation
	if rot != new_rot:
		rot = (new_rot / slide_count + rot * 3) / 4
	if not no_rotate:
		sprite.rotation = rot

	# check platforms underneath
	if platform_raycast:
		platform_raycast.rotation = sprite.rotation
		if platform_raycast.is_colliding():
			var shape_id = platform_raycast.get_collider_shape()
			var collider = platform_raycast.get_collider()
			if collider is StaticBody2D and collider:
				var owner_id = collider.shape_find_owner(shape_id)
				var hit_node = collider.shape_owner_get_owner(owner_id)
				if check_child_collision(hit_node):
					if platforms.find(hit_node) != -1 :
						allow_fall_trough_timer.start()

	if sprite.animation != "climb" and not no_gravity:
		apply_gravity()
	if add_move_n_slide:
		velocity = move_and_slide(velocity, Vector2.UP, true, 4, max_angle) #apply velocity to movement




