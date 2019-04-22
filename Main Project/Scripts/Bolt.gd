extends "res://scripts/projectile.gd"

func setup(direction,pointSet,teamParam,spd=boltspeed,dam=damage,kb=knockback):
	boltspeed = spd ; damage = dam ; knockback = kb ; angle = direction ; moving = true ; point = pointSet; team=teamParam
func _ready():
	traillength = 25
	set_process(false)
	set_physics_process(true)
	look_at(point)
	trail.remove_point(0)
	return
