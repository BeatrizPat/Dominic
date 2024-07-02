extends CharacterBody2D

@export var starting_direction : Vector2 = Vector2(0, 0.1)
@export var tile_size : int = 16
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var ray = $RayCast2D
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var moving = false
var game_over_flag = false
var animation_speed = 2
var current_direction

# Inicializa a direção do player e ajusta posição centralizado na tile
func _ready():
	add_to_group("global")
	animation_tree.active = true
	update_animation_parameters(starting_direction)
	state_machine.travel("idle")
	#position = position.snapped(Vector2.ONE * tile_size)
	#position += Vector2.ONE * tile_size/2
	
func _process(delta):
	if (not moving) and (not game_over_flag): state_machine.travel("idle")
	#print(state_machine.get_current_node())

# Recebe os eventos de teclado
func _unhandled_input(event):
	if moving or game_over_flag:
		return
	for dir in inputs.keys():
		if event.is_action(dir):
			move(dir)
			current_direction = dir
		
# Função de movimentação do player
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	update_animation_parameters(ray.target_position)
	if !ray.is_colliding():
		moving = true
		state_machine.travel("walk")
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		moving = false
		#Condição de game over se o player colidiu com o enemy
	if ray.is_colliding(): 
		var regex = RegEx.new()
		regex.compile("Enemy")
		var result = regex.search(ray.get_collider().name)
		print(ray.get_collider().name)
		if result: 
			ray.get_collider().game_over()
			game_over()
		
# Atualização de animação
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)

#Função para animação de game over e ncerra o jogo
func game_over():
	print("gameover")
	game_over_flag = true
	set_process_input(false)
	state_machine.travel("End")
	print(current_direction)
	var animation_name = "over_"+current_direction
	print(animation_name)
	animation_player.play(animation_name)
	#animation_tree.set("parameters/game over/blend_position", current_direction)
	await 500
	
func animation_game_over_finished():
	print("change scene")
	get_tree().call_group("global", "game_over_scene")
		
