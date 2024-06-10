extends CharacterBody2D

@export var move_speed : float = 1
@export var starting_direction : Vector2 = Vector2(0, 0.1)
@export var tile_size : int = 16
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var currPos = Vector2(56,32)
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var moving = false
var animation_speed = 2
@onready var ray = $RayCast2D

# Inicializa a direção do player e ajusta posição centralizado na tile
func _ready():
	update_animation_parameters(starting_direction)
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func _process(delta):
	if not moving: state_machine.travel("idle")

# Recebe os eventos de teclado
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action(dir):
			move(dir)
		
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
	if ray.is_colliding(): 
		var regex = RegEx.new()
		regex.compile("Enemy")
		var result = regex.search(ray.get_collider().name)
		if result: get_tree().change_scene_to_file("res://level/end_scene.tscn")
		
	

# Atualização de animação
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		
func game_over():
	

		
