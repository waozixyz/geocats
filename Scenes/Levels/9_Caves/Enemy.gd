extends Node2D

onready var hp_bar = get_parent().get_node("HUD/Hp")

onready var sprite = $Body/AnimatedSprite
onready var eyes = $Eyes
onready var boulder = get_parent().get_node("Boulder")
onready var bullet = $Bullet
onready var laser_explosion = $LaserExplosion

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
var shoot_sequence = 0
var to_shoot = 0
var move_speed = 200

var hp = 100

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
func move(end_face):
	var dest
	face = end_face
	if end_face == "wyrd":
		dest = Vector2(250, 550)
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
	bullets.append(b)
	get_parent().add_child(b)

func _disable_colliders():
	collider_wyrd.disabled = true
	collider_norna.disabled = true

func _enable_collider():
	if face == "wyrd":
		collider_wyrd.disabled = false
	if face == "norna":
		collider_norna.disabled = false
	
func _process(_delta):
	# update hp_bar
	hp_bar.rect_scale.x = hp / 100
	# ears follow enemy position
	ears.position = position + Vector2(0, -52)

	# when facing the screen and not moving
	# enable ears and damage
	if _is_face() and moves.size() == 0:
		ears.visible = true
		for child in ears.get_children():
			if child.name == face:
				child.visible = true
				
			else:
				child.visible = false
	else:
		ears.visible = false
	
	if shoot_sequence == 1:
		if to_shoot > 0:
			_shoot(-1)
			_shoot(1)
			to_shoot -= 1
	# if moving do this
	if moves:
		for i in range(moves.size()):
			if range(moves.size()).has(i):
				var move = moves[i]
				sprite.playing = true
				_disable_colliders()
				if not move.is_active() and _is_face():
					_enable_collider()
					sprite.playing = false
					remove_child(move)
					moves.remove(i)
					to_shoot = 10
					shoot_sequence = 1
					mode += 1
				

	# if there are bullets do this
	for i in range(bullets.size()):
		if range(bullets.size()).has(i):
			var bullet = bullets[i]
			bullet.rotation_degrees -= 5
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
	beam.visible =true
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
	attack.eye = "left"
	attacks.append(attack)
	attack = attack.duplicate()
	attack.ticker = -5
	attack.pos.x -= 53
	attack.target.x += 53
	attack.eye = "right"
	attacks.append(attack)

# make spiral attack
func spiral_attack():
	var attack = {}
	attack.frame = sprite.frame
	attack.pos = position + Vector2(-20, 10)
	attack.shape = "ball_lazer"
	attack.ticker = 0
	attack.eye = "left"
	attacks.append(attack)
