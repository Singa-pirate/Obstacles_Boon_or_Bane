extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_start"):
		start_game()

func _on_Button_pressed():
	start_game()

func start_game():
	get_parent().get_node("Astronaut").start()
	for child in get_parent().get_children():
		if child.is_in_group("Meteor"):
			child.start()
	get_parent().get_node("Indicator").queue_free()
	queue_free()
