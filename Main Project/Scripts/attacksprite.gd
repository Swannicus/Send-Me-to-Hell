extends Node2D

func _ready():
	return




func _on_anim_animation_finished(anim_name):
	#self.queue_free()
	#Don't need to destroy, it just gets moved and reanimated every time
	$Sprite/anim.play("idle")
	return
