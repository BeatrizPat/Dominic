extends CharacterBody2D

@export var starting_direction : Vector2 = Vector2(0, 0.1)
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var ray = $RayCast2D #movement ray
@onready var ray_object = $RayCast2D2 #obstacles ray
var tile_size = GlobalVariables.tile_size
var ray_object_lenght = 19
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var moving = false
var game_over_flag = GlobalVariables.game_over_flag
var animation_speed = 2
var current_direction
var current_direction_name
var attacking = false

# Inicializa a direção do player e ajusta posição centralizado na tile
func _ready():
	add_to_group("global")
	add_to_group("enter")
	animation_tree.active = true
	update_animation_parameters(starting_direction)
	animation_travel('idle')
	current_direction = starting_direction
	current_direction_name = "down"
	print(inputs['right'])
	
func _process(_delta):
	if(game_over_flag): animation_travel('over')
	for dir in inputs.keys():
		if Input.is_action_just_released(dir):
			animation_travel('idle')
	if Input.is_action_just_pressed('space'): 
		animation_travel('space')
		obstacles()
	
func update_animation(direction):
	if(direction != Vector2.ZERO):
		state_machine.travel('walk')
	else:
		state_machine.travel('idle')
		

# Recebe unhandle events de teclado
func _unhandled_input(event):
	if moving or game_over_flag:
		return
	for dir in inputs.keys():
		if event.is_action(dir):
			move(dir)
			current_direction = inputs[dir]
			current_direction_name = dir
		
# Função de movimentação do player
func move(dir):
	#atualiza o raycast
	ray.target_position = inputs[dir] * tile_size
	ray_object.target_position = inputs[dir] * ray_object_lenght
	ray.force_raycast_update()
	update_animation_parameters(ray.target_position)
	if !ray.is_colliding():
		moving = true
		animation_travel('walk')
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		moving = false
	
	#Condição de game over se o player colidiu com o enemy
	else:
		if(ray_object.get_collider()):
			var r1 = (ray_object.get_collider().name).contains('enemy')
			var r2 = (ray_object.get_collider().name).contains('Enemy')
			if r1 or r2 :
				ray.get_collider().game_over()
				game_over()
		
# Atualização de animação
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/space/blend_position", move_input)
		animation_tree.set("parameters/over/blend_position", move_input)

#Função para animação de game over e encerra o jogo
func game_over():
	print("gameover")
	game_over_flag = true
	moving = false
	set_process_input(false)
	animation_travel('over')
	print(state_machine.get_current_node())
	
func animation_game_over_finished():
	print("change scene")
	get_tree().call_group("global", "game_over_scene")
	
func obstacles():
	ray_object.force_raycast_update()
	if !ray_object.is_colliding() or (!ray.is_colliding() and check_collider_istile(current_direction)):
		get_tree().call_group("enter", "instantiate_obstacle", self.global_position + (current_direction * tile_size), current_direction)
	elif ray_object.is_colliding():
		if (ray_object.get_collider().name).contains('obstaculo'):
			get_tree().call_group("enter", "free_obstacle", ray_object.get_collider(), current_direction)
		
func check_collider_istile(direction):
	if ray_object.is_colliding():
		if ray_object.get_collider().name.contains('Tile'):
			return true
	else: return false
	
func animation_travel(nome_state):
	state_machine.travel(nome_state)
	
