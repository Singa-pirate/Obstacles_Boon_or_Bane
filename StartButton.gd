extends Control

func _on_Button_pressed():
	get_parent().get_node("Astronaut").start()
	queue_free()
