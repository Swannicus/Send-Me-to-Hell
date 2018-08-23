extends "res://Engine/entity.gd"

const speed = 30

var movedir = Vector2(0,0)
var lookdir = Vector2(0,0)
var movetimer_length = 60
var movetimer = 0
var damager
export var damage = 1
const ammoscene = preload("res://Scenes/ammo.tscn")
const coinscene = preload("res://Scenes/coin.tscn")
var stun = 0

func _ready():
#	$anim.play("default")
	movedir = dir.rand()
	lookdir = movedir
	animswitch("walk")
	health = 4
	damager = $Area2D
	

func takedamage(damaget,knockbackt,source):
	health = health-damaget
	stun = 10
	var directionkb = global_position - source
	print(str(directionkb))
	move_and_slide(knockbackt*directionkb.normalized(), Vector2(0,0))
	if health <= 0:
		_Death()
		var drop = ammoscene.instance()
		var type = randi()%4+4
		var coindrop
		var i = randi()%4
		$"../../Floor".add_child(drop)
		drop.global_position = self.global_position
		drop.settype(randi()%4+4)
		print("Drop")
		while i > 0:
			i -= 1
			coindrop = coinscene.instance()
			get_parent().add_child(coindrop)
			coindrop.global_position = self.global_position
			coindrop.apply_impulse(Vector2(0,0),Vector2(randf()*401-200,randf()*401-200))
		$soundDeath.play(0)
		set_physics_process(false)
		set_process(false)
		return
	print("Health",health)
	animswitch2("damaged")

func _physics_process(delta):
	if stun > 0:
		stun -= 1
		return
	movement_loop(movedir,60)
	attack_loop()
	direction_loop()

func direction_loop():
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = dir.rand()
		lookdir = movedir
		movetimer = movetimer_length
		animswitch2("walkleft")
#		animswitch("walk")

func attack_loop():
	var overlappingbodies = damager.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if not body.is_in_group("player"):
			return
		print("attackloop"+str(self))
		body.takedamage(damage)
	return

func _on_anim_animation_finished(anim_name):
	_Death2()
	#if randi(1,10) > 5:
	
