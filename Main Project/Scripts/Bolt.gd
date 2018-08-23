#Bolt.gd
extends Area2D

export var boltspeed = 450
var speedx = 1
var speedy = 1
var motion = Vector2()
var damage = 2
var knockback = 800
var angle = Vector2()
var moving = true
var decaytime = 0

func setup(direction,spd=boltspeed,dam=damage,kb=knockback):
#	look_at(get_global_mouse_position())
	boltspeed = spd ; damage = dam ; knockback = kb
	angle = direction
	look_at(angle)


func _ready():
	set_process(false)
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
			set_physics_process(false)
			set_process(true)
			$sound.play(0)
		if not body.is_in_group("enemy"):
			return
		moving = false
		if body.is_in_group("enemy"):
			body.takedamage(damage,knockback,global_position)
			$sound.play(0)
		#self.get_parent().remove_child(self)
		body.add_child(self)
		set_physics_process(false)
		set_process(true)