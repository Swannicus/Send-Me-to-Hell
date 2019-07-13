extends "res://Scripts/weaponRanged.gd"
var rayLength = 2000
var attackBool = false
var classPoint
var spaceState
onready var rayCaster = $Sprite/muzzle/rayCast

func _physics_process(delta):
	rayCaster.set_global_rotation(0)
	spaceState = get_world_2d().direct_space_state
	var mousePos = get_global_mouse_position()
	if mousePos.x-self.global_position.x < 0 :
		rayCaster.set_cast_to((Vector2(1,-1)*(get_global_mouse_position() - muzzle.global_position)).normalized()*rayLength)
	else:
		rayCaster.set_cast_to((get_global_mouse_position() - muzzle.global_position).normalized()*rayLength)
	if attackBool:
		attackBool = false
		beamGen(muzzle.global_position,(classPoint-muzzle.global_position),6)

func attackAction(point):
	attackBool = true
	classPoint = point
	#stuff
	sound.play(0)
	rpc("remote_attack",get_parent().get_parent().get("player_id"),point)
	currentCooldown = cooldown

func beamGen(source,angle,bouncesRemaining=0,Length=2000):
	var circle = load("res://debugcircle.tscn").instance()
	var rayDict = spaceState.intersect_ray(source,angle.normalized()*Length+source,[self],1)
	print(rayDict)
	print(angle)
	#lastHit = rayDict["collider"]
	var rayCollision = rayDict["position"]
	var rayNormal = rayDict["normal"]
	get_parent().get_parent().get_parent().add_child(circle)
	circle.global_position =  rayCollision
	var proj = projScene.instance()
	var hit = rayCaster.get_collision_point()
	var reflectAngle = rayCaster.get_collision_normal()
	var beam
	for i in (rayDict["position"]-source).length()/23:
		beam = load("res://Scenes/weapons/beamStraightPoison.tscn").instance()
		beam.global_position = source+angle.normalized()*23*i
		get_parent().get_parent().get_parent().add_child(beam)
		beam.set_rotation(angle.angle())
		beam.damage(damage,knockback,(self.global_position).normalized()*23,get_parent().get_parent().team)
	beam = load("res://Scenes/weapons/impactStraightPoison.tscn").instance()
	beam.global_position = source+angle.normalized()*(rayCollision-source).length()
	get_parent().get_parent().get_parent().add_child(beam)
	beam.set_rotation(angle.angle())
	#beamGen(beam.global_position,reflectAngle)
	beam.damage(damage,knockback,(self.global_position).normalized()*23,get_parent().get_parent().team)
	if bouncesRemaining >= 1:
		beamGen(rayCollision+rayNormal*5,angle-2*rayNormal*(angle*rayNormal),bouncesRemaining-1)
	return

func pickUp():
	return("res://Scenes/weapons/orbPoison.tscn")