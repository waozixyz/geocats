extends Node2D

onready var sprite = $Body/AnimatedSprite
onready var eyes = $Eyes
onready var boulder = get_parent().get_node("Boulder")
onready var bullet = $Bullet
onready var laser_explosion = $LaserExplosion
onready var collider = $Body/CollisionPolygon2D
onready var ears = get_parent().get_node("Ears")
onready var beam = $Beam

var bullets = []
var tweens = []
var face = "norna"
var mode = "ready"

func _eyes(side, active):
	var eye = eyes.get_node(side)
	eye.frame = 0
	eye.visible = active
	eye.playing = active

func _shoot_target(attack):
	var bullet = bullet.duplicate()
	bullet.position = attack.pos
	bullet.scale = Vector2(4, 4)
	bullet.visible = true 

	var tween = Tween.new()
	get_parent().add_child(tween)
	tween.interpolate_property(bullet, "position", attack.pos, attack.target, 3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
	get_parent().add_child(bullet)
	bullets.append(bullet)
	tweens.append(tween)

func _is_face():
	if face == "wyrd" and (sprite.frame == 2 or sprite.frame == 7 or sprite.frame == 8):
		return true
	elif face == "norna" and (sprite.frame == 0 or sprite.frame == 4 or sprite.frame == 5):
		return true
	else:
		return false
var attacks = []
var moves = []
func move(end_face):
	var dest
	face = end_face
	if end_face == "wyrd":
		dest = Vector2(250, 550)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "position", self.position, dest, 3, Tween.TRANS_QUART)
	tween.start()
	moves.append(tween)

func _process(_delta):
	# ears follow enemy position
	ears.position = position + Vector2(0, -52)

	if _is_face() and moves.size() == 0:
		ears.visible = true
		for child in ears.get_children():
			if child.name == face:
				child.visible = true
				
			else:
				child.visible = false
	else:
		ears.visible = false
	if moves:
		for i in range(moves.size()):
			if range(moves.size()).has(i):
				var move = moves[i]
				sprite.playing = true
				collider.disabled = true
				if not move.is_active() and _is_face():
					collider.disabled = false
					sprite.playing = false
					remove_child(move)
					moves.remove(i)
					mode = "attack"

	for i in range(bullets.size()):
		if range(bullets.size()).has(i):
			var bullet = bullets[i]
			bullet.rotation_degrees -= 5
			
			if not tweens[i].is_active() or bullet.dead:				
				get_parent().remove_child(bullet)
				bullets.remove(i)
				get_parent().remove_child(tweens[i])
				tweens.remove(i)		

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
func beam_attack():
	beam.visible =true
	beam.sprite.frame = 0
	beam.sprite.playing = true

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
