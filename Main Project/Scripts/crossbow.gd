extends Node2D

const boltscene = preload("res://Scenes/weapons/Bolt.tscn")
var cooldown = 0

func _ready():

	pass

#func _process(delta):


func _physics_process(delta):
	if cooldown > 0:
		cooldown -= 1

func lookLoop():
	$"..".look_at(get_global_mouse_position())
	if get_global_mouse_position().x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if get_global_mouse_position().x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))

func attack():
	var bolt = boltscene.instance()
	var angle = get_global_mouse_position() - $Sprite/muzzle.global_position
	if cooldown == 0:
		$Sound.play(0)
		bolt.setup(angle.normalized())
		get_parent().get_parent().get_parent().add_child(bolt)
		bolt.global_position = $Sprite/muzzle.global_position
		rpc("remote_attack",get_parent().get_parent().player_id,get_global_mouse_position())
		cooldown = 30

func remote_attack(id,target):
	var bolt = boltscene.instance()
	var angle = target - $Sprite/muzzle.global_position
	bolt.setup(angle.normalized())
	get_parent().get_parent().get_parent().add_child(bolt)
	bolt.global_position = $Sprite/muzzle.global_position
