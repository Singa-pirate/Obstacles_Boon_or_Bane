extends Control

func _on_Button_pressed():
	get_parent().get_node("Astronaut").start()
	get_parent().get_node("Indicator").queue_free()
	queue_free()
