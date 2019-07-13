extends "res://scripts/weaponMelee.gd"

func _ready():
	set_physics_process(true)
	set_process(true)
	cooldown = 1
	weaponID = 3
	damage = 3
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")


func pickUp():
	return("res://Scenes/weapons/axe.tscn")