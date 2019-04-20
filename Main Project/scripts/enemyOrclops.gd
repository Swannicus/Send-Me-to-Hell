extends "res://scripts/enemyRoot.gd"

func _init():
	points = 25
	scenePath = "res://Scenes/enemyOrclops.tscn"
	chance = 50

func _ready():
	random.setSeed(randi())
	health = 4
	target = Vector2(0,0)
	speed = 30
	damage = 3
	damageCooldown = []
	focusFloat = 0.3
	#Get a footstep noise
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	set_nav(get_parent().get_parent())
	weaponNode = load("res://Scenes/weapons/sword.tscn").instance()
	add_child(weaponNode)
	weaponNode.global_position = global_position
	weaponRange.get_node("CollisionShape2D").get_shape().set_radius(weaponNode.get_node("weapon").AIRange)
	pass

func direction_loop(delta):
	if dirTimer <= 0:
		var d = random.randFloat()
		target = Vector2(random.randRangeFloat(-1,1),random.randRangeFloat(-1,1)).normalized()
		if d >= focusFloat:
			if path.size() != 0:
				target = path[0].normalized()+global_position
		dirTimer = dirTimerMax
	dirTimer -= delta

func attack_loop():
	var overlappingBodies = weaponRange.get_overlapping_bodies()
	if not overlappingBodies:
		return
	for body in overlappingBodies:
		if body.is_in_group("player"):
			weaponNode.get_node("weapon").attack(body.global_position)
	return