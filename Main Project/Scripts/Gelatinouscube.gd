extends "res://engine/entity.gd"

const speed = 20

var movetimer_length = 60
var movetimer = 0

func _ready():
#	$anim.play("default")
	movedir = dir.rand()
	lookdir = movedir
	animswitch("walk")

func _physics_process(delta):
	movement_loop()

	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = dir.rand()
		lookdir = movedir
		movetimer = movetimer_length
		animswitch("walk")
	
	