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

func _ready():
	random.setSeed(get_name())
#	$anim.play("default")
	movedir = Vector2(random.randRangeInt(-1,1),random.randRangeInt(-1,1))
	lookdir.x = movedir.x
	animswitch2("idle")
	health = 2
	damager = $Area2D

func movement_loop(movedir,speed):
	var motion = movedir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func takedamage(damaget,knockbackt,source):
	health = health-damaget
	stun = 10
	var directionkb = global_position - source
	move_and_slide(knockbackt*directionkb.normalized(), Vector2(0,0))
	if health <= 0:
		$CollisionShape2D.disabled = true
		_Death()
		var drop = ammoscene.instance()
		var coindrop
		var i = random.randRangeInt(0,4)
		get_parent().add_child(drop)
		drop.global_position = self.global_position
		drop.settype(random.randRangeInt(4,7))
		while i > 0:
			i -= 1
			coindrop = coinscene.instance()
			get_parent().add_child(coindrop)
			coindrop.global_position = self.global_position
			coindrop.apply_impulse(Vector2(0,0),Vector2(random.randFloat()*401-200,random.randFloat()*401-200))
		$soundDeath.play(0)
		set_physics_process(false)
		set_process(false)
		return
	animswitch2("damaged")

func _physics_process(delta):
	if stun > 0:
		stun -= 1
		return
	attack_loop()
	movement_loop(movedir,60)
	direction_loop()

func direction_loop():
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = Vector2(random.randRangeFloat(-1,1),random.randRangeFloat(-1,1))
		lookdir.x = movedir.x
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
		body.takedamage(damage)
	return

func _on_anim_animation_finished(anim_name):
	_Death2()
	#if randi(1,10) > 5:
	
