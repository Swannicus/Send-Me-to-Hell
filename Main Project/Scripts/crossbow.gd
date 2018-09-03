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

func _process(delta):
	._process(delta)

func _physics_process(delta):
	._physics_process(delta)

func attack():
	var bolt = boltscene.instance()
	var angle = get_global_mouse_position() - $Sprite/muzzle.global_position
	if currentCooldown <= 0:
		$Sound.play(0)
		bolt.setup(angle.normalized())
		bolt.global_position = $Sprite/muzzle.global_position
		get_parent().get_parent().get_parent().add_child(bolt)
		rpc("remote_attack",get_parent().get_parent().player_id,get_global_mouse_position())
		currentCooldown = cooldown

func remote_attack(id,target):
	var bolt = boltscene.instance()
	var angle = target - $Sprite/muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = $Sprite/muzzle.global_position
