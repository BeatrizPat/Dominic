extends Control

func _on_texture_button_pressed():
	change_scene()
	
func _unhandled_input(event):
	if event.is_action_pressed('enter'):
		change_scene()
	
func change_scene():
	get_tree().change_scene_to_file("res://level/game_level.tscn")
