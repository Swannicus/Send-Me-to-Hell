extends KinematicBody2D

const speed = 100
var movedir = Vector2()
var lookdir = Vector2()
var spritedir = "down"

func movement_loop():
	var motion = movedir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))
	
func spritedir_loop():
	match lookdir:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"
		Vector2(0,-1):
			spritedir = "up"
		Vector2(0,1):
			spritedir = "down"

func animswitch(animation):
	var newanim = str(animation,spritedir)
	if $Sprite/anim.current_animation != newanim:
		$Sprite/anim.play(newanim)
	
	