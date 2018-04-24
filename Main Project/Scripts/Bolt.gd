#Bolt.gd
extends Area2D

export var boltspeed = 200
var speedx = 1
var speedy = 1
var motion = Vector2()
var damage = 1
var knockback = 5
var angle = Vector2()

func setup(direction,spd=boltspeed,dam=damage,kb=knockback):
	look_at(get_global_mouse_position())
	boltspeed = spd ; damage = dam ; knockback = kb
	angle = direction
	

func _ready():
	return

func _process(delta):
	motion = Vector2(speedx,speedy) * angle * boltspeed
	global_position += motion * delta

func _physics_process(delta):
	var overlappingbodies = get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if not body.is_in_group("enemy"):
			return
		set_process(false)
		body.takedamage(damage,knockback,global_position)
		self.get_parent().remove_child(self)
		body.add_child(self)
		set_physics_process(false)