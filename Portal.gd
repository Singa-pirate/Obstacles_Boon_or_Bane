extends StaticBody2D

func _on_PortalBox_body_entered(body):
	if body.name == "Astronaut":
		get_parent().get_parent().next_level()
