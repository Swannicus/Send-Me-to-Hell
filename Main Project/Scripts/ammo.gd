extends Node2D
export var reagent = 1

func _ready():
	$Sprite.set_frame(reagent+3)
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