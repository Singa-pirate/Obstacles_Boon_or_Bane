extends Button

func _on_pressed():
	get_parent().get_parent().go_prev_chapter()
