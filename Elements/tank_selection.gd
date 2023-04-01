extends Control


func _on_big_tank_button_pressed():
	get_parent().get_node("Astronaut").add_big_tank()


func _on_small_tank_button_pressed():
	get_parent().get_node("Astronaut").add_small_tanks(get_parent().small_tank_count)
