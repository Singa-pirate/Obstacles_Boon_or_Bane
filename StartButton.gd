extends Control

func _on_Button_pressed():
	get_parent().get_node("Astronaut").start()
	for child in get_parent().get_children():
		if child.get_class() == "meteor":
			child.start()
	get_parent().get_node("Indicator").queue_free()
	queue_free()
