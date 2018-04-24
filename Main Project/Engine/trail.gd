extends Line2D

var point
var target
export var traillength = 10

func _ready():
	target = get_parent()
	pass

func _process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	point = target.global_position
	add_point(point)
	while get_point_count() > traillength:
		remove_point(0)
	pass
