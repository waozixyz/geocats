extends StaticBody2D

onready var sprite = $Body
onready var eyes = $Eyes
onready var boulder = get_parent().get_node("Boulder")
onready var round_bullet = $RoundBullet
onready var laser_explosion = $LaserExplosion
var bullets = []
var tweens = []
var mode = "ready"

func _eyes(side, active):
	var eye = eyes.get_node(side)
	eye.frame = 0
	eye.visible = active
	eye.playing = active

func _shoot_target(attack):
	var bullet = round_bullet.duplicate()
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

func _face():
	if mode == "left":
		return (sprite.frame == 2 or sprite.frame == 7 or sprite.frame == 8)	

var attacks = []
var moves = []
func move(dir):
	var dest
	mode = dir
	if mode == "left":
		dest = Vector2(250, 550)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "position", self.position, dest, 3, Tween.TRANS_QUART)
	tween.start()
	moves.append(tween)

func _process(_delta):
	for i in range(moves.size()):
		if range(moves.size()).has(i):
			var move = moves[i]
			sprite.playing = true
			if not move.is_active() and _face():
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
				making_beam = true
			elif attack.ticker == 200:
				if i <= attacks.size() - 2:
					_eyes(attack.eye, false)
				attacks.remove(i)
var making_beam = false
var beam_ticker = 0
func attack_target(target_pos):
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

#	if making_beam and not tween.is_active():
#		making_beam = false
#		beam_ticker = 0
#		return true
#
