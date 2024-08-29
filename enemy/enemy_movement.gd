extends CharacterBody2D
class_name enemy_movement
@onready var ray = $RayCast2D
@onready var ray_aux = $RayCast2D2
var movement = true
@export var tile_size = 16
var dir = [Vector2.RIGHT,
			Vector2.LEFT,
			Vector2.UP,
			Vector2.DOWN]
var current_direction = 2

func _ready():
	var rand = 0
	add_to_group("global")
	$AnimationPlayer.play("walk_front")
	
func change_direction():
	if current_direction == 2:
		current_direction = 3
		$AnimationPlayer.play("walk_back")
	else:
		current_direction = 2
		$AnimationPlayer.play("walk_front")
			
func _physics_process(delta):
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
	ray_aux.target_position = dir[2] * tile_size
	ray_aux.force_raycast_update()
	if ray_aux.is_colliding():
		ray_aux.target_position = dir[3] * tile_size
		ray_aux.force_raycast_update()
		if ray_aux.is_colliding():
			return true
		else: false
	else: false
	
func game_over():
	movement = false
	queue_free()
