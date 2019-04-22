extends "res://scripts/destructible.gd"

func onDeath():
	for monster in Globals.monstersInLevelArray:
		monster.global_position = global_position+Vector2(random.randRangeFloat(-60,60),random.randRangeFloat(-60,60))