extends Node2D

onready var hp_bar = get_parent().get_node("HUD/HpBar/Red")

onready var sprite = $Body/AnimatedSprite
onready var eyes = $Eyes
onready var boulder = get_parent().get_node("Boulder")
onready var bullet = $Bullet

onready var ears = get_parent().get_node("Ears")
onready var beam = $Beam
onready var collider_wyrd = $Body/Wyrd
onready var collider_norna = $Body/Norna
# lists
var attacks = []
var bullets = []
var moves = []

var face = "wyrd"
var mode = 0
var shooting
var moving
var shoot_sequence = 0
var move_sequence = 0
var to_shoot_left = 0
var to_shoot_right = 0
var move_speed = .5
var vulnerable = true
export var hp = 100
var rage = 0
var def = 1
func _eyes(side, active):
	var eye = eyes.get_node(side)
	eye.frame = 0
	eye.visible = active
	eye.playing = active

func _shoot_target(attack):
	var b = bullet.duplicate()
	b.position = attack.pos
	b.scale = Vector2(4, 4)
	b.visible = true 
	b.mode = "tween"
	b.tween.interpolate_property(b, "position", attack.pos, attack.target, 3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	b.tween.start()
	get_parent().add_child(b)
	bullets.append(b)

# check if facing screen with the appropriate enemy face
func _is_face():
	if face == "wyrd" and (sprite.frame == 2 or sprite.frame == 7 or sprite.frame == 8):
		return true
	elif face == "norna" and (sprite.frame == 0 or sprite.frame == 4 or sprite.frame == 5):
		return true
	else:
		return false

# move enemy function
func move():
	var dest
	var faces = ["wyrd", "norna"]
	face = faces[round(rand_range(0, 1))]
	if rage == 0:
		if move_sequence % 3 == 0:
			dest = Vector2(250, 550)
		elif move_sequence % 3 == 1:
			dest = Vector2(1060, 260)
		else:
			dest = Vector2(970, 620)
	elif rage == 1:
		dest = Vector2(rand_range(250, 1060), rand_range(260, 505))
		if dest.x < 600 and dest.y < 500:
			dest.y += 200
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "position", self.position, dest, 3 / move_speed, Tween.TRANS_QUART)
	tween.start()
	moves.append(tween)

# simple shoot
func _shoot(eye):
	var b = bullet.duplicate()
	var offset = Vector2(0, 10)
	offset.x += 25 * eye

	b.position = position + offset
	b.scale = Vector2(4, 4)
	b.visible = true 
	b.mode = "spiral"
	b.deg = int(rand_range(0, 360))
	if rage == 0:
		b.speed = 4
		b.dmg = 20
	elif rage == 1:
		b.speed = 7
		b.dmg = 20
	bullets.append(b)
	get_parent().add_child(b)

# prepare eyes
func _prep_eyes(side):
	# get the eye node
	var eye = eyes.get_node(side)
	
	# if eye not playing already start it
	if not eye.playing:
		eye.frame = 0
		eye.visible = true
		eye.playing = true

	# find last frame of eye animation
	var end = eye.get_sprite_frames().get_frame_count(eye.animation) - 1
	
	# if eye animation fineshs hide the eye and return true
	if eye.frame == end:
		eye.playing = false
		eye.visible = false
		return true
	else:
		return false
	
# disable collisions so player can't attack
func disable_colliders():
	collider_wyrd.disabled = true
	collider_norna.disabled = true

# enable collision depending on the face in the front
func _enable_collider():
	if face == "wyrd":
		collider_wyrd.disabled = false
	if face == "norna":
		collider_norna.disabled = false

func _process(_delta):
	# update hp_bar
	if hp >= 0:
		hp_bar.rect_scale.x = hp / 100

	# hp_bar color
	if hp <= 10:
		hp_bar.get_stylebox("panel", "").bg_color = Color(0.6, 0.1, 0, 1)
	elif hp <= 40:
		hp_bar.get_stylebox("panel", "").bg_color = Color(0.6, 0.3, 0, 1)
	else:
		hp_bar.get_stylebox("panel", "").bg_color = Color(0.6, 0, 0.3, 1)
	# ears follow enemy position
	ears.position = position + Vector2(0, -52)

	# when facing the screen and not moving
	# enable ears and damage
	if _is_face() and moves.size() == 0 and vulnerable:
		ears.visible = true
		for child in ears.get_children():
			if child.name == face:
				child.visible = true
			else:
				child.visible = false
	else:
		ears.visible = false
	

	if shooting:
		if to_shoot_left >= 1:
			var eye = -1
			if _prep_eyes("left"):
				_shoot(eye)
				if rage == 1 and int(rand_range(1, 3)) > 1:
					_shoot(eye)
		
				to_shoot_left -= 1
		if to_shoot_right >= 1:
			var eye = 1
			if _prep_eyes("right"):
				_shoot(eye)
				if rage == 1 and int(rand_range(1, 3)) > 1:
					_shoot(eye)
				to_shoot_right -= 1
		if to_shoot_left == 0 and to_shoot_right == 0:
			move_sequence +=  int(rand_range(1,3))
			move()
			shooting = false


	# if moving do this
	if moves:
		for i in range(moves.size()):
			if range(moves.size()).has(i):
				var move = moves[i]
				sprite.playing = true
				disable_colliders()

				if not move.is_active() and _is_face():
					_enable_collider()
					sprite.playing = false
					remove_child(move)
					moves.remove(i)
					
					var shots
					if rage == 0:
						shots = int(rand_range(2, 5))
					elif rage == 1:
						shots = int(rand_range(4, 8))
					to_shoot_left = shots
					to_shoot_right = shots
					shoot_sequence += 1
					shooting = true
					mode += 1

	# if there are bullets do this
	for i in range(bullets.size()):
		if range(bullets.size()).has(i):
			var bullet = bullets[i]
			if (bullet.mode == "tween" and not bullet.tween.is_active()) or bullet.dead:
				get_parent().remove_child(bullet)
				bullets.remove(i)

	# if there is an attack do this
	for i in range(attacks.size()):
		if range(attacks.size()).has(i):
			var attack = attacks[i]
			attack.ticker +=1
			if attack.ticker == 1:
				_eyes(attack.eye, true)
			elif attack.ticker == 160:
				_shoot_target(attack)
			elif attack.ticker == 200:
				if i <= attacks.size() - 2:
					_eyes(attack.eye, false)
				attacks.remove(i)
				
# special beam attack				
func beam_attack():
	beam.visible = true
	beam.sprite.frame = 0
	beam.sprite.playing = true

# bullet attack with target
func bullet_attack(target_pos):
	var attack = {}
	attack.target = target_pos
	attack.frame = sprite.frame
	attack.pos = position + Vector2(-55, 10)
	attack.shape = "ball_lazer"
	attack.ticker = 0
	attack.eye = -1
	attacks.append(attack)
	attack = attack.duplicate()
	attack.ticker = -5
	attack.pos.x -= 53
	attack.target.x += 53
	attack.eye = 1
	attacks.append(attack)

# make spiral attack
func spiral_attack():
	var attack = {}
	attack.frame = sprite.frame
	attack.pos = position + Vector2(-20, 10)
	attack.shape = "ball_lazer"
	attack.ticker = 0
	attack.eye = -1
	attacks.append(attack)
