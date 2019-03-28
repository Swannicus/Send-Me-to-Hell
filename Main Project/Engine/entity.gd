extends KinematicBody2D
var spritedir = "down"
var dead = false
var health = 1
var stun = 0
var random = preload("res://Engine/randomLib.gd").new()
	
func spritedir_loop(lookdir):
	match lookdir:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"
#		Vector2(0,-1):
#			spritedir = "up"
#		Vector2(0,1):
#			spritedir = "down"

func _Death():
	if dead == false:
		animswitch2("death")
		if is_in_group("enemy"):
			remove_from_group("enemy")
			$CollisionShape2D.disabled = true
			add_to_group("corpse")
		dead = true

func _Death2():
	if dead == true:
		#animswitch2("dead")
		set_physics_process(false)
		set_process(false)
#		self.remove_from_group("enemy")
#		self.add_to_group("corpse",false)

func animswitch(animation):
	var newanim = str(animation,spritedir)
	if $Sprite/anim.current_animation != newanim:
		$Sprite/anim.play(newanim)

func animswitch2(animation):
	var newanim = str(animation)
	if $Sprite/anim.current_animation != newanim:
		$Sprite/anim.play(newanim)
	
