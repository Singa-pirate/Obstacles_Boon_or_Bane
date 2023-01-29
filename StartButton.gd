extends Control

func _on_Button_pressed():
	get_parent().get_node("Player").start()
	queue_free()
