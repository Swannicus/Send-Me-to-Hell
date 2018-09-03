extends "res://scripts/weaponRoot.gd"
const projScene = preload("res://Scenes/weapons/Bolt.tscn")

func _physics_process(delta):
	._physics_process(delta)

func _process(delta):
	._process(delta)

func attack():
	var proj = projScene.instance()
	var angle = get_global_mouse_position() - $Sprite/muzzle.global_position
	if currentCooldown <= 0:
		$Sound.play(0)
		proj.setup(angle.normalized())
		proj.global_position = $Sprite/muzzle.global_position
		get_parent().get_parent().get_parent().add_child(proj)
		rpc("remote_attack",get_parent().get_parent().player_id,get_global_mouse_position())
		cooldown = 30

func remote_attack(id,target):
	var bolt = projScene.instance()
	var angle = target - $Sprite/muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = $Sprite/muzzle.global_position
