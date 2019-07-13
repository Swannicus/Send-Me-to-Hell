extends "res://scripts/weaponMelee.gd"

var r = 50
var circlePoints = 6
var circleTime = 0.02
var circleOverlap = 1

func _ready():
	set_physics_process(true)
	set_process(true)
	cooldown = 0.25
	weaponID = 3
	damage = 2
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")

func attackAction2(point):
	var x
	var y
	var i = 0
	var delay = circleTime/circlePoints
	var startingAngle
	t = Timer.new()
	t.set_wait_time(delay)
	add_child(t)
	sound.play()
	startingAngle = (point - global_position).angle()
	for i in (circlePoints+circleOverlap):
		x = r * cos((2 * PI * i / circlePoints)+startingAngle)
		y = r * sin((2 * PI * i / circlePoints)+startingAngle)
		circleArray.append(Vector2(x,y))
	t.start()
	t.connect("timeout",self,"circleAttack")

func circleAttack():
	if circleArray.size() == 0:
		if is_instance_valid(t):
			t.queue_free()
		return
	attackAction(circleArray.pop_front()+get_parent().get_parent().global_position)

func pickUp():
	return("res://Scenes/weapons/sword.tscn")