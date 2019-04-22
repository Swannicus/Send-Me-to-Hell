extends "res://scripts/enemyWielder.gd"


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
	weaponArray.append("res://Scenes/weapons/crossbow.tscn")
	weaponArray.append("res://Scenes/weapons/sword.tscn")
	weaponArray.append("res://Scenes/weapons/axe.tscn")
	equipWeapon()
	#Get a footstep noise
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	set_nav(get_parent().get_parent())
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

