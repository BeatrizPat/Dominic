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

func _ready():
	add_to_group("global")
	add_to_group("enter")
	score_label.text = str(int(score))
	tempo_restante = int(timer.get_time_left())
	label_timer = str(tempo_restante)
	timer.start()
	items_count = items.get_child_count()

func _process(delta):
	tempo_restante = timer.get_time_left()
	update_timer_label(tempo_restante)
	check_game_score()
	
func pontuacao_update():
	print("update")
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
	
func instantiate_obstacle(position):
	var obstaculo_instance = obstaculo_scene.instantiate()
	add_child(obstaculo_instance)
	obstaculo_instance.name = 'obstaculo'
	obstaculo_instance.global_position = position
	
func free_obstacle(object):
	object.queue_free()

func play_again():
	print("play again")#get_tree().change_scene_to_file("res://level/game_level.tscn")
	
func check_game_score():
	if score == items_count:
		get_tree().call_group("global", "game_win")
		get_tree().change_scene_to_file("res://assets/end_scene/win_scene.tscn")
		
