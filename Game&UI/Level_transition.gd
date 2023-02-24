extends Node2D



func _on_Home_button_pressed():
	get_parent().go_home()


func _on_Next_level_button_pressed():
	get_parent().next_level()


func _on_Replay_level_button_pressed():
	get_parent().replay_this_level()
