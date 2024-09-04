extends Control

func _ready():
	add_to_group("global")

func _on_texture_button_pressed():
	get_tree().call_group("global", "play_again")
	get_tree().change_scene_to_file("res://level/game_level.tscn")
	
