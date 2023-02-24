extends Node2D



func _on_Home_button_pressed():
	get_parent().go_home_from_popup()


func _on_Next_level_button_pressed():
	get_parent().next_level_from_popup()


func _on_Replay_level_button_pressed():
	get_parent().replay_this_level_from_popup()
