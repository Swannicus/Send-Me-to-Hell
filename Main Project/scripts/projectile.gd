extends Area2D

export var boltspeed = 700
var speedx = 1
var speedy = 1
var motion = Vector2()
var damage = 2
var knockback = 800
var angle = Vector2()
var moving = false
var decaytime = 0
var point
var lifeSpan = 1
var random = preload("res://Engine/randomLib.gd").new()
onready var trail = $trail
onready var sprite = $Sprite
var team
export var traillength = 25

func setup(direction,pointSet,teamParam,spd=boltspeed,dam=damage,kb=knockback):
	boltspeed = spd ; damage = dam ; knockback = kb ; angle = direction ; moving = true ; point = pointSet; team=teamParam

func _ready():
	set_process(false)
	trail.remove_point(0)
	return

func _process(delta):
	decaytime += delta
	if decaytime >= lifeSpan:
		call_deferred("free")
		#self.queue_free()

func _physics_process(delta):
	physics_loop(delta)

func physics_loop(delta):
	var overlappingbodies = get_overlapping_bodies()
	if moving:
		motion = Vector2(speedx,speedy) * angle * boltspeed
		global_position += motion * delta
		trail.global_position = Vector2(0,0)
		trail.global_rotation = 0
		trail.add_point(global_position)
		while trail.get_point_count() > traillength:
			trail.remove_point(0)
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("wall"):
			moving = false
			set_physics_process(false)
			set_process(true)
			$sound.play(0)
			trail.queue_free()
		if body.get("team") != team and body.get("team") != null:
			moving = false
			$sound.play(0)
			trail.queue_free()
			body.takedamage(damage,knockback,global_position)
			set_physics_process(false)
			set_process(true)