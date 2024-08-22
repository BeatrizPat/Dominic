extends Area2D

@onready var ray = $RayCast2D
@onready var ray_object = $RayCast2D2
var ray_lenght = 16
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enter")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#verifica colisão do raycast
func verificar_ray(direction):
	alter_ray_object(direction)
	ray_object.force_raycast_update()
	if ray_object.is_colliding():
		print(ray_object.get_collider().name)
		return true
	else: return false

#altera direção do raycast
func alter_ray(direction):
	ray.target_position = direction * ray_lenght
	
func alter_ray_object(direction):
	ray_object.target_position = direction * ray_lenght
	
func get_collider_object(direction):
	alter_ray_object(direction)
	ray_object.force_raycast_update()
	return ray_object.get_collider()

func check_collider_istile(direction):
	if ray_object.is_colliding():
		if ray_object.get_collider().name.contains('Tile'):
			return true
	else: return false
	
