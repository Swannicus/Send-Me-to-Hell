#Bolt.gd
extends "res://scripts/projectile.gd"

func setup(direction,pointSet,teamParam,spd=boltspeed,dam=damage,kb=knockback):
	boltspeed = spd ; damage = dam ; knockback = kb ; angle = direction ; moving = true ; point = pointSet; team=teamParam

func _ready():
	boltspeed = 600
	traillength = 25
	set_process(false)
	set_physics_process(true)
	look_at(point)
	trail.remove_point(0)
	return

func _process(delta):
	decaytime += delta
	if decaytime >= 1:
		self.queue_free()

func physics_loop(delta):
	var overlappingbodies = get_overlapping_bodies()
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
		if body.get("team") != team and body.get("team") != null:
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
			body.takedamage(damage,knockback,global_position)
		#self.get_parent().remove_child(self)