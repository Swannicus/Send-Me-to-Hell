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
			weaponNode.get_node("weapon").attack(body.global_position)
	return