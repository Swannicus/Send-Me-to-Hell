extends "res://scripts/weaponMelee.gd"

const projScene = preload("res://Scenes/weapons/iceCrystal.tscn")

func _ready():
	set_physics_process(true)
	set_process(true)
	cooldown = 0.26
	weaponID = 3
	damage = 2
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	ammoCost = 1
	ammoType = 4
	AIRange = 50
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")

func attack(point):
	#not called here
	if currentCooldown <= 0:
		attackAction(point)
		currentCooldown = cooldown

func pickUp():
	return("res://Scenes/weapons/swordIce.tscn")

func extraAttack(point):
	var proj = projScene.instance()
	var angle = point - $muzzle.global_position
	if get_parent().get_parent().ammo4 <= ammoCost:
		return
	get_parent().get_parent().ammo4 -= ammoCost
#	get_parent().get_parent().hud.get_node("blue").set_value(get_parent().get_parent().ammo4)
	proj.setup(angle.normalized(),point,get_parent().get_parent().team)
	proj.global_position = $muzzle.global_position
	get_parent().get_parent().get_parent().add_child(proj)
