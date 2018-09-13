#Bolt.gd
extends Area2D

export var boltspeed = 600
var speedx = 1
var speedy = 1
var motion = Vector2()
var damage = 2
var knockback = 800
var angle = Vector2()
var moving = false
var decaytime = 0
var point
var trail
export var traillength = 25

func setup(direction,newPoint,spd=boltspeed,dam=damage,kb=knockback):
#	look_at(get_global_mouse_position())
	boltspeed = spd ; damage = dam ; knockback = kb; point = newPoint;
	angle = direction
	moving = true


func _ready():
	set_process(false)
	trail = $trail
	look_at(point)
	trail.remove_point(0)
	return

func _process(delta):
	decaytime += delta
	if decaytime >= 1:
		self.queue_free()

func _physics_process(delta):
	var overlappingbodies = get_overlapping_bodies()
	var sprite = $Sprite
	if moving:
		motion = Vector2(speedx,speedy) * angle * boltspeed
		global_position += motion * delta
		trail.global_position = Vector2(0,0)
		trail.global_rotation = 0
		trail.add_point(sprite.global_position)
		while trail.get_point_count() > traillength:
			trail.remove_point(0)
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		print (str(body.get_groups()))
		if body.is_in_group("wall"):
			moving = false
			set_physics_process(false)
			set_process(true)
			$sound.play(0)
			if motion.x < 0 :
				if self.scale != Vector2(-1,1):
					self.apply_scale(Vector2(-1,1))
			if motion.x > 0 :
				if self.scale != Vector2(1,1):
					self.apply_scale(Vector2(-1,1))
			rotation_degrees = 0
			$Sprite/anim.play("impact")
			trail.queue_free()
		if not body.is_in_group("enemy"):
			return
		moving = false
		$sound.play(0)
		if motion.x < 0 :
			if self.scale != Vector2(-1,1):
				self.apply_scale(Vector2(-1,1))
		if motion.x > 0 :
			if self.scale != Vector2(1,1):
				self.apply_scale(Vector2(-1,1))
		rotation_degrees = 0
		$Sprite/anim.play("impact")
		trail.queue_free()
		body.add_child(self)
		set_physics_process(false)
		set_process(true)
		if body.is_in_group("enemy"):
			body.takedamage(damage,knockback,global_position)
		#self.get_parent().remove_child(self)