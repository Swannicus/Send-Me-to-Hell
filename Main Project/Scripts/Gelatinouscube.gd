extends "res://engine/entity.gd"

const speed = 20

var movetimer_length = 60
var movetimer = 0
export var damage = 1

func _ready():
#	$anim.play("default")
	movedir = dir.rand()
	lookdir = movedir
	animswitch("walk")
	health = 99999

func takedamage(damaget,knockbackt,source):
	health = health-damaget
	var directionkb = position - source
	move_and_slide(knockbackt*directionkb.normalized(), Vector2(0,0))
	if health <= 0:
		_Death()
		set_physics_process(false)
		set_process(false)
		return
	print("Health",health)
	animswitch2("damaged")

func _physics_process(delta):
	movement_loop()
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
	var overlappingbodies = $Area2D.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if not body.is_in_group("player"):
			return
		body.takedamage(damage)
		print("taking damage")


func _on_anim_animation_finished(anim_name):
	_Death2()
