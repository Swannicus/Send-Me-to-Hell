extends Node2D
var reagent = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func settype(type):
	var sprite = $Sprite
	print(str(type)+"type")
	sprite.set_frame(type)
	reagent = type-3