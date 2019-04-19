extends "res://scripts/enemyRoot.gd"
onready var damager = $damageBox

func _init():
	points = 10
	scenePath = "res://Scenes/enemyGelatinousCube.tscn"
	chance = 60

func _ready():
	random.setSeed(randi())
	health = 3
	target = Vector2(0,0)
	speed = 1
	damage = 3
	damageCooldown = []
	#Get a footstep noise
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	set_nav(get_parent().get_parent())
	pass

func process(delta):
	if stun > 0:
		stun -= 1
		return
#	movement_loop(delta)
	attack_loop()
	pathfind_loop(delta)
	direction_loop(delta)
	pass

func _physics_process(delta):
	pass

func set_nav(new_nav):
	nav = new_nav
	update_path()

func pathfind_loop(delta):
	pathfindTimer += delta
	if pathfindTimer >= 1:
		for b in detector.get_overlapping_bodies():
			if b.is_in_group("player"):
				goal = b.global_position
				update_path()
				break

func movement_loop(delta):
	apply_impulse(Vector2(0,0),speed*target)

func update_path():
	path = nav.get_simple_path(get_global_position(),goal,true)
	if path.size() == 0:
		return #add the teleport back into nav mesh

func direction_loop(delta):
	if dirTimer <= 0:
		var d = random.randFloat()
		target = Vector2(random.randRangeFloat(-1,1),random.randRangeFloat(-1,1)).normalized()
		if d >= 100:
			if path.size() != 0:
				target = path[0].normalized()
		dirTimer = 1
	dirTimer -= delta

func attack_loop():
	var overlappingbodies = damager.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("player"):
			body.takedamage(damage)
	return
