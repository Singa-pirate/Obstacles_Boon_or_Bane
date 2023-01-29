extends StaticBody2D

func _on_PortalBox_body_entered(body):
	get_parent().get_parent().next_level()
