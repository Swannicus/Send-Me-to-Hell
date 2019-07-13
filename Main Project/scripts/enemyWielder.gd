extends "res://scripts/enemyRoot.gd"
onready var weaponRange = $weaponRange
var weaponNode 
var weaponArray= []
var wielding = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if wielding:
		weaponNode.get_node("weapon").monsterLookLoop(target)

func equipWeapon():
	weaponNode = load(weaponArray[random.randRangeInt(1,weaponArray.size()-1)]).instance()
	add_child(weaponNode)
	weaponNode.global_position = global_position
	weaponRange.get_node("CollisionShape2D").get_shape().set_radius(weaponNode.get_node("weapon").AIRange)
	wielding=true
	weaponNode.get_node("weapon").get_node("pickUpRadius").queue_free()

func attack_loop():
	var overlappingBodies = weaponRange.get_overlapping_bodies()
	if not overlappingBodies:
		return
	for body in overlappingBodies:
		if body.get("team") == Globals.PLAYERS:
			weaponNode.get_node("weapon").attackdown(body.global_position)
	return

func _Death():
	if dead == false:
		_anim("death",true)
		if is_in_group("enemy"):
			set_collision_mask_bit(1,false)
			set_collision_layer_bit(1,false)
			set_collision_layer_bit(4,true)
			team = null
			ammoDrop.drop(global_position)
			for i in random.randRangeInt(bountyMinimum,bountyMaximum):
				coinDrop.drop(global_position)
			#sound.stream = load("DEATHSOUND")
			sound.play(0)
			remove_child(weaponNode)
			get_parent().add_child(weaponNode)
			weaponNode.global_position = global_position
			weaponNode.get_node("weapon").add_child(load("res://Scenes/weapons/pickUpRadius.tscn").instance())
			set_physics_process(false)
			set_process(false)
			Globals.livingMonsters -= 1
		dead = true