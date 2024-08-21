extends Area2D

@onready var ray = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enter")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func verificar_ray():
	if ray.is_colliding():
		return false
	else: return true
