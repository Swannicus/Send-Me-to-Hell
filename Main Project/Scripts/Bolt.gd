#Bolt.gd
extends Area2D

export var boltspeed = 200
var speedx = 1
var speedy = 1
var motion = Vector2()
var damage = 1
var knockback = 5
var angle = Vector2()
var moving = true
var decaytime = 0

func setup(direction,spd=boltspeed,dam=damage,kb=knockback):
	look_at(get_global_mouse_position())
	boltspeed = spd ; damage = dam ; knockback = kb
	angle = direction
	self.look_at(angle)
	set_process(false)
	

func _ready():
	return

func _process(delta):
	decaytime += 1
	if decaytime >= 60:
		self.queue_free()

func _physics_process(delta):
	var overlappingbodies = get_overlapping_bodies()
	if moving:
		motion = Vector2(speedx,speedy) * angle * boltspeed
		global_position += motion * delta
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		print (str(body.get_groups()))
		if body.is_in_group("wall"):
			moving = false
		if not body.is_in_group("enemy"):
			return
		moving = false
		if body.is_in_group("enemy"):
			body.takedamage(damage,knockback,global_position)
		#self.get_parent().remove_child(self)
		body.add_child(self)
		set_physics_process(false)
		set_process(true)