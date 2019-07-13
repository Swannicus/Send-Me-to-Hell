extends Sprite
var lifeSpan = 0.15
var life = 0
func _ready():
	$anim.play("idle")
	pass # Replace with function body.

func _process(delta):
	life += delta
	if life >= lifeSpan:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
