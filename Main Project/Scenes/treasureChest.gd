extends Node2D

func _ready():
	$Sprite/AnimationPlayer.play("idle")
	pass

func open():
	var coin1
	var i = randi()%11+1
	while i != 30:
		i += 1
		$Sprite/AnimationPlayer.play("dead")
		coin1 = load("res://Scenes/coin.tscn").instance()
		get_parent().add_child(coin1)
		coin1.set_global_position(self.get_global_position())
		coin1.apply_impulse(Vector2(0,0),Vector2(randf()*601-300,randf()*601-300))
		#spray coins everywhere bro
	$pickup.queue_free()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
