extends "res://scripts/weaponRoot.gd"
const projScene = preload("res://Scenes/weapons/Bolt.tscn")
onready var muzzle = $Sprite/muzzle

func _ready():
	AIRange = 100


func _physics_process(delta):
	._physics_process(delta)

func _process(delta):
	._process(delta)

func attack(point):
	var proj = projScene.instance()
	var angle = point - muzzle.global_position
	if currentCooldown <= 0:
		$Sound.play(0)
		proj.setup(angle.normalized(),point,get_parent().get_parent().get("team"))
		proj.global_position = muzzle.global_position
		get_parent().get_parent().get_parent().add_child(proj)
		rpc("remote_attack",get_parent().get_parent().get("player_id"),point)
		currentCooldown = cooldown

func remote_attack(id,target):
	var bolt = projScene.instance()
	var angle = target - muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = muzzle.global_position
