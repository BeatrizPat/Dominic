extends Node2D

@onready var score_label := $Control/score as Label
@onready var timer_label := $Control/time as Label
@onready var timer := $Timer
@onready var obstaculo_scene = preload("res://objects/obstaculo.tscn")
@onready var items = $items

var score := 0
var tempo_restante := 0
var label_timer
var items_count 
var tile_size = 16

func _ready():
	add_to_group("global")
	add_to_group("enter")
	score_label.text = str(int(score))
	tempo_restante = int(timer.get_time_left())
	label_timer = str(tempo_restante)
	timer.start()
	items_count = items.get_child_count()
	print(items_count)

func _process(delta):
	tempo_restante = timer.get_time_left()
	update_timer_label(tempo_restante)
	check_game_score()
	
func pontuacao_update():
	score += 1
	score_label.text = str(int(score))
	
func update_timer_label(time):
		label_timer = str(time/60, ":", time%60) 
		timer_label.text = label_timer
	
func _on_timer_timeout():
	print("game over timer")
	get_tree().call_group("global", "game_over")
	
func game_over_scene():
	get_tree().change_scene_to_file("res://level/end_scene.tscn")
	
func instantiate_obstacle(position, direction):
	var obstaculo_instance =  instance_obj(position, direction)
	while(1):
		if !obstaculo_instance.check_collider_istile(direction):
			if(!obstaculo_instance.verificar_ray(direction)):
				print('game instantiate object')
				position = position + (direction * tile_size)
				obstaculo_instance = instance_obj(position, direction)
			else: break
		else:break

func instance_obj(position, direction):
	var obstaculo_instance = obstaculo_scene.instantiate()
	add_child(obstaculo_instance)
	obstaculo_instance.name = 'obstaculo'
	obstaculo_instance.global_position = position
	obstaculo_instance.alter_ray(direction)
	return obstaculo_instance
	
func free_obstacle(object, direction):
	if object:
		if(object.name.contains('obstaculo')):
			var next_object = object.get_collider_object(direction)
			object.animation_free()
			free_obstacle(next_object, direction)
		else: return
	return

func play_again():
	print("play again")
	
func check_game_score():
	if score == items_count:
		get_tree().call_group("global", "game_win")
		
func game_win():
	get_tree().change_scene_to_file("res://level/win_scene.tscn")
	
		
