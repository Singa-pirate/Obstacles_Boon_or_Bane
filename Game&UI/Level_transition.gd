extends Node2D

func _ready():
	self.position = get_viewport_rect().size / 2
	$Sprite2D.scale = Vector2(2,2)
	$Label.set_position(Vector2(-100,-100))
	$Home_button.set_position(Vector2(-150,0))
	$Next_level_button.set_position(Vector2(-60,0))
	$Replay_level_button.set_position(Vector2(60,0))

func _on_Home_button_pressed():
	get_parent().go_home_from_popup()

func _on_Next_level_button_pressed():
	get_parent().next_level_from_popup()

func _on_Replay_level_button_pressed():
	get_parent().replay_this_level_from_popup()
