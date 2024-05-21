extends CharacterBody2D

@export var move_speed : float = 1
@export var starting_direction : Vector2 = Vector2(0, 0.1)
@export var tile_size : int = 16

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var currPos = [100, 50]
func _ready():
	update_animation_parameters(starting_direction)
func _input(event):
	if event.is_action_pressed("right"):
		currPos[0] += tile_size

	elif event.is_action_pressed("left"):
		currPos[0] -= tile_size
		
	elif event.is_action_pressed("up"):
		currPos[1] -= tile_size

	elif event.is_action_pressed("down"):
		currPos[1] += tile_size

	self.position = Vector2(currPos[0], currPos[1])
	
func _physics_process(_delta):
	#atualiza animação
	update_animation_parameters(Vector2(currPos[0], currPos[1]))
	velocity = Vector2(currPos[0], currPos[1]) * move_speed
	#move_and_slide()
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
		

