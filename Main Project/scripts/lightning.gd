extends Node2D
var curve
var points = []
var color=Color(0.2, 1.0, .7, .8)
var d = 0

func _ready():
	curve = Curve2D.new()
	curve.add_point(Vector2(1,1))
	curve.add_point(Vector2(1,1))
	pass

func createLightning(sp,ep,c=color):
	color = c
	curve.clear_points()
	curve.add_point(sp)
	curve.add_point(ep)
	curve.set_point_out(0,Vector2(randf()*2*(sp.distance_to(ep))-sp.distance_to(ep),randf()*2*(sp.distance_to(ep))-sp.distance_to(ep)))
	curve.set_point_in(1,Vector2(randf()*2*(sp.distance_to(ep))-sp.distance_to(ep),randf()*2*(sp.distance_to(ep))-sp.distance_to(ep)))
	return

func _draw():
	points = curve.tessellate()
	for i in range(points.size()-1):
		draw_line(points[i],points[i+1],color)

func _process(delta):
	d += delta
	if d >0.5:
		createLightning(Vector2(randi()%300+100,randi()%300+100),Vector2(randi()%300+100,randi()%300+100))
		update()
		d = 0