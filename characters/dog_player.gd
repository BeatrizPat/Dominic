extends CharacterBody2D

@export var move_speed : float = 50
@export var starting_direction : Vector2 = Vector2(0, 0.1)
#parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	#bloqueia movimento diagonal
	if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		input_direction.y = 0
	elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
		input_direction.x = 0
	else:
		input_direction = Vector2.ZERO
	
	#normaliza movimento
	input_direction = input_direction.normalized()
	#atualiza animação
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()
	pick_new_state()
	
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
		

