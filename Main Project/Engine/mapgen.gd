extends Sprite

#I don't understand this, I got it from a russian tutorial on youtube ;_;

var width = 50
var height = 50
var grid = []
var N = 1; var S = 2; var E = 4; var W = 8
var direction = [N, S, E, W]
var sum_cell =0
var odd_cell = Vector2()

func _ready():
	for i in range(0,width):
		grid.append([])
		for j in range(0,height):
			grid[i].append(0)
			if ((i % 2 != 0 && j % 2 !=0) && (i < height-1 && j < width-1)):
				sum_cell += 1; pass

func walk():
	var x = 1
	var y = 1
	while sum_cell != 0:
		var dict = {E:Vector2(x-2,y), S:Vector2(x,y+2), W:Vector2(x+2,y), N:Vector2(x,y-2)}
		randomize()
		direction = [N, S, E, W]
		direction = direction[randi()%direction.size()]
		odd_cell = dict[direction]
		odd_cell.x = max(odd_cell.x,1); odd_cell.x = min(odd_cell.x, width-1)
		odd_cell.y = max(odd_cell.y,1); odd_cell.y = min(odd_cell.y, width-1)
		if direction == N: grid[odd_cell.x][odd_cell.y+1] = 1
		if direction == S: grid[odd_cell.x][odd_cell.y-1] = 1
		if direction == E: grid[odd_cell.x+1][odd_cell.y] = 1
		if direction == W: grid[odd_cell.x-1][odd_cell.y] = 1
		grid[x][y] = 1
		x = odd_cell.x; y = odd_cell.y
		sum_cell = sum_cell - 1
		odd_cell = Vector2(0,0)

func _draw():
	walk()
	for y2 in range(0,grid.size()):
		for x2 in range(0,grid.size()):
			if grid[y2][x2] == 1:
				draw_rect(Rect2(x2*20,y2*20,18,18),Color(1,0.7,1))
		