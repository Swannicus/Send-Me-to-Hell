extends "res://scripts/weaponRanged.gd"

func _ready():
	projScene = preload("res://Scenes/weapons/cannonBall.tscn")
	projSpeed = 600
	cooldown = 3
	weaponID = 3
	damage = 6
	knockback = 1500
	shakeValue = 40
	shakeDur = 5
	pass

func attackAction(point):
	var proj = projScene.instance()
	var angle = point - muzzle.global_position
	var muzzleFlare = load("res://Scenes/weapons/cannonMuzzleFlare.tscn").instance()
	add_child(muzzleFlare)
	muzzleFlare.global_position = muzzle.global_position
	muzzleFlare.look_at(point)
	sound.play(0)
	proj.setup(angle.normalized(),point,get_parent().get_parent().get("team"),projSpeed,damage,knockback)
	proj.global_position = muzzle.global_position
	get_parent().get_parent().get_parent().add_child(proj)
	rpc("remote_attack",get_parent().get_parent().get("player_id"),point)
	currentCooldown = cooldown

func pickUp():
	return("res://Scenes/weapons/cannon.tscn")

