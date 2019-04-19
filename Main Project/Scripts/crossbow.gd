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

func pickUp():
	return("res://Scenes/weapons/crossbow.tscn")

