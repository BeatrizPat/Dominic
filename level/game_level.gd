extends Node2D

@onready var score_label := $Control/score as Label
@onready var timer_label := $Control/time as Label
@onready var timer := $Timer
@onready var obstaculo_scene = preload("res://objects/obstaculo.tscn")

var score := 0
var tempo_restante := 0
var label_timer

func _ready():
	add_to_group("global")
	add_to_group("enter")
	score_label.text = str(int(score))
	tempo_restante = int(timer.get_time_left())
	label_timer = str(tempo_restante)
	timer.start()


func _process(delta):
	tempo_restante = timer.get_time_left()
	update_timer_label(tempo_restante)
	
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
