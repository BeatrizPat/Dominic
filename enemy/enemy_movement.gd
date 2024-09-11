extends CharacterBody2D
class_name enemy_movement
@onready var ray = $RayCast2D
@onready var ray_aux = $RayCast2D2
var movement = true
var tile_size = GlobalVariables.tile_size
var dir = [Vector2.RIGHT,
			Vector2.LEFT,
			Vector2.UP,
			Vector2.DOWN]
var current_direction = 2
var x=0
var player
func _ready():
	add_to_group("global")
	$AnimationPlayer.play("walk_front")
	player = get_node("res://player/dog_player.gd")
	print(player)
	
func change_direction():
	
	if current_direction == 2-x:
		current_direction = 3-x
		$AnimationPlayer.play("walk_back")
	else:
		current_direction = 2-x
		$AnimationPlayer.play("walk_front")
			
func _physics_process(_delta):
	if movement:
		ray.target_position = dir[current_direction] * tile_size/2
		ray.force_raycast_update()
		if ray.is_colliding():
			if (ray.get_collider().name).contains('DogPlayer'): 
				#print('enemy',ray.get_collider().name)
				ray.get_collider().game_over()
				game_over()
			else: change_direction()
		velocity = dir[current_direction] * tile_size
		move_and_slide()
	if check_stuck():
		movement = false
	else: movement = true
	
func check_stuck():
	ray_aux.target_position = dir[2-x] * tile_size
	ray_aux.force_raycast_update()
	if ray_aux.is_colliding():
		ray_aux.target_position = dir[3-x] * tile_size
		ray_aux.force_raycast_update()
		if ray_aux.is_colliding():
			return true
	
func game_over():
	movement = false
	queue_free()
