extends Node2D
var currentWall = 0
var Walls
var Floor

func _ready():
	Walls = $Walls
	Floor = $Floors
	pass

func getS1(xCell,yCell):
	var surround
	surround = [		[0,-1],
				[-1,0],			[1,0],
						[0,1]		]
	for i in range(0,surround.size()):
		surround[i][0]+=xCell
		surround[i][1]+=yCell
	return surround

func getS2(xCell,yCell):
	var surround2
	surround2 = [[-1,-1]		,	[1,-1],
				[-1,1]		,	[1,1]]
	for i in range(0,surround2.size()):
		surround2[i][0]+=xCell
		surround2[i][1]+=yCell
	return surround2

func _process(delta):
	var surround
	var surround2
	var binary
	if Input.is_action_just_released("ui_down"):
		surround = getS1(5,5)
		surround2 = getS2(5,5)
		currentWall += 1
		binary = currentWall
		if currentWall < 16:
			$Walls/mainLabel.text = str(currentWall)
		if currentWall >= 16:
			$Walls/mainLabel.text = "Corner"+str(currentWall)
		for i in surround:
			Floor.set_cell(i[0],i[1],-1)
		for i in surround2:
			Floor.set_cell(i[0],i[1],-1)
		if binary < 16:
			if binary >= Globals.S:
				binary -= Globals.S
				Floor.set_cell(surround[3][0],surround[3][1],19)
			if binary >= Globals.E:
				binary -= Globals.E
				Floor.set_cell(surround[2][0],surround[2][1],19)
			if binary >= Globals.W:
				binary -= Globals.W
				Floor.set_cell(surround[1][0],surround[1][1],19)
			if binary >= Globals.N:
				binary -= Globals.N
				Floor.set_cell(surround[0][0],surround[0][1],19)
		if binary >= 16:
			binary -= 16
			if binary >= Globals.SE:
				binary -= Globals.SE
				Floor.set_cell(surround2[3][0],surround2[3][1],19)
			if binary >= Globals.SW:
				binary -= Globals.SW
				Floor.set_cell(surround2[2][0],surround2[2][1],19)
			if binary >= Globals.NE:
				binary -= Globals.NE
				Floor.set_cell(surround2[1][0],surround2[1][1],19)
			if binary >= Globals.NW:
				binary -= Globals.NW
				Floor.set_cell(surround2[0][0],surround2[0][1],19)
		placeWall(5,5)

func placeFloor(xCell,yCell):
	Walls.set_cell(xCell,yCell,-1)
	if randf() <=0.6:
		Floor.set_cell(xCell,yCell,19)
	else:
		Floor.set_cell(xCell,yCell,20)
	placeWall(xCell,yCell-1)
	placeWall(xCell+1,yCell-1)
	placeWall(xCell+1,yCell)
	placeWall(xCell+1,yCell+1)
	placeWall(xCell,yCell+1)
	placeWall(xCell-1,yCell+1)
	placeWall(xCell-1,yCell)
	placeWall(xCell-1,yCell-1)

func placeWall(xCell,yCell):
	var wallstate = getWallState(xCell,yCell)
	Walls.set_cell(xCell,yCell,Globals.wallArray[getWallState(xCell,yCell)])

func getWallState(xCell,yCell):
	var type = 0
	var surround = getS1(xCell,yCell)
	var surround2 = getS2(xCell,yCell)
	if Floor.get_cell(surround[0][0],surround[0][1]) in [19,20,21,22]:
		type += Globals.N
	if Floor.get_cell(surround[1][0],surround[1][1]) in [19,20,21,22]:
		type += Globals.W
	if Floor.get_cell(surround[2][0],surround[2][1]) in [19,20,21,22]:
		type += Globals.E
	if Floor.get_cell(surround[3][0],surround[3][1]) in [19,20,21,22]:
		type += Globals.S
	if type == 0:
		type = 16
		if Floor.get_cell(surround2[0][0],surround2[0][1]) in [19,20,21,22]:
			type += Globals.NW
		if Floor.get_cell(surround2[1][0],surround2[1][1]) in [19,20,21,22]:
			type += Globals.NE
		if Floor.get_cell(surround2[2][0],surround2[2][1]) in [19,20,21,22]:
			type += Globals.SW
		if Floor.get_cell(surround2[3][0],surround2[3][1]) in [19,20,21,22]:
			type += Globals.SE
	return type