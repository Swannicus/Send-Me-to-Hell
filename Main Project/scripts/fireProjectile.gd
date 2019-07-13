extends "res://scripts/projectile.gd"


func setup(direction,pointSet,teamParam,spd=boltspeed,dam=damage,kb=knockback):
	boltspeed = spd ; damage = dam ; knockback = kb ; angle = direction ; moving = true ; point = pointSet; team=teamParam

func _ready():
	lifeSpan = 2
	traillength = 0
	set_physics_process(true)
	return

func physics_loop(delta):
	var overlappingbodies = get_overlapping_bodies()
	if moving:
		motion = Vector2(speedx,speedy) * angle * boltspeed
		global_position += motion * delta
		angle = angle+Vector2(random.randVect2(-1,1,-1,1)
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.get("team") != team and body.get("team") != null:
			$sound.play(0)
			body.takedamage(damage,knockback,global_position)
