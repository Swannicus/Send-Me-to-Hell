extends Sprite

var image1 = preload("res://Rogue1.png")
var image2 = preload("res://Rogue2.png")
export var speed = 100
var vel = Vector2()


func _init():
	if Globals.character1 == 0:
		self.texture = image1
	if Globals.character1 == 1:
		self.texture = image2
	pass
	
func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://CharacterSelect.tscn")
	if Input.is_action_just_pressed("ui_right"):
		vel += Vector2(speed, 0)
	if Input.is_action_just_released("ui_left"):
		vel += Vector2(speed, 0)
	if Input.is_action_just_pressed("ui_left"):
		vel += Vector2(-speed, 0)
	if Input.is_action_just_released("ui_right"):
		vel += Vector2(-speed, 0)
	if Input.is_action_just_pressed("ui_up"):
		vel += Vector2(0, -speed)
	if Input.is_action_just_released("ui_down"):
		vel += Vector2(0, -speed)
	if Input.is_action_just_pressed("ui_down"):
		vel += Vector2(0, speed)
	if Input.is_action_just_released("ui_up"):
		vel += Vector2(0, speed)
	self.position = (self.position + vel * delta)
