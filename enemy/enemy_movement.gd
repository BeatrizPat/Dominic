extends CharacterBody2D
class_name enemy_movement
@onready var ray = $RayCast2D
var movement = true
@export var tile_size = 16
var dir = [Vector2.RIGHT,
			Vector2.LEFT,
			Vector2.UP,
			Vector2.DOWN]
var rand
# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = 0
	add_to_group("global")
	pass # Replace with function body.
func change_direction():
	if rand == 2:
		rand = 3
	else: rand = 2
			
func _physics_process(delta):
	if movement:
		ray.target_position = dir[rand] * tile_size/2
		ray.force_raycast_update()
		if ray.is_colliding():
			var regex = RegEx.new()
			regex.compile("DogPlayer")
			var result = regex.search(ray.get_collider().name)
			print(ray.get_collider().name)
			if result: 
				ray.get_collider().game_over()
				game_over()
			else: change_direction()
		velocity = dir[rand] * tile_size
		if rand == 2:
			$AnimationPlayer.play("walk_back")
		else: $AnimationPlayer.play("walk_front")
		move_and_slide()
	#detect_collision()
func game_over():
	movement = false
	queue_free()
