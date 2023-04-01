extends Control

func _on_Button_pressed():
	get_parent().get_node("Astronaut").start()
	for child in get_parent().get_children():
		if child.is_in_group("Meteor"):
			child.start()
	get_parent().get_node("Indicator").queue_free()
	if get_parent().get_node("TankSelection") != null:
		get_parent().get_node("TankSelection").queue_free()
	queue_free()
