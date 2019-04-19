extends "res://scripts/weaponRanged.gd"
const boltscene = preload("res://Scenes/weapons/Bolt.tscn")


func _ready():
	cooldown = 1.5
	weaponID = 3
	damage = 3
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	pass

func attack(point):
	var bolt = boltscene.instance()
	var angle = point - muzzle.global_position
	if currentCooldown <= 0:
		$Sound.play(0)
		bolt.setup(angle.normalized(),point)
		bolt.global_position = muzzle.global_position
		get_parent().get_parent().get_parent().add_child(bolt)
		rpc("remote_attack",get_parent().get_parent().player_id,point)
		currentCooldown = cooldown

func pickUp():
	return("res://Scenes/weapons/crossbowLightning.tscn")

func remote_attack(id,target):
	var bolt = boltscene.instance()
	var angle = target - muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = muzzle.global_position
