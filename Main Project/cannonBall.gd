extends "res://scripts/projectile.gd"

func setup(direction,pointSet,teamParam,spd=boltspeed,dam=damage,kb=knockback):
	boltspeed = spd ; damage = dam ; knockback = kb ; angle = direction ; moving = true ; point = pointSet; team=teamParam
func _ready():
	traillength = 25
	set_process(false)
	set_physics_process(true)
	#look_at(point)
	trail.remove_point(0)
	return

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
			$sound.play(0)
			body.takedamage(damage,knockback,global_position)
