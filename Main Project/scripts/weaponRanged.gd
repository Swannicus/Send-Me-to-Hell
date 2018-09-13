extends "res://scripts/weaponRoot.gd"
const projScene = preload("res://Scenes/weapons/Bolt.tscn")

func _physics_process(delta):
	._physics_process(delta)

func _process(delta):
	._process(delta)

func attack(point):
	var proj = projScene.instance()
	var angle = point - $Sprite/muzzle.global_position
	if currentCooldown <= 0:
		$Sound.play(0)
		proj.setup(angle.normalized(),point)
		proj.global_position = $Sprite/muzzle.global_position
		get_parent().get_parent().get_parent().add_child(proj)
		rpc("remote_attack",get_parent().get_parent().player_id,point)
		currentCooldown = cooldown

func remote_attack(id,target):
	var bolt = projScene.instance()
	var angle = target - $Sprite/muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = $Sprite/muzzle.global_position
