extends StaticBody2D


var portal_opened = false


func _physics_process(delta):
	if not portal_opened:
		var enemies_killed = true
		for child in get_parent().get_children():
			if child.is_in_group("Enemies"):
				enemies_killed = false
				break
		
		if enemies_killed:
			portal_opened = true
			open_portal()


func open_portal():
	# TODO
	print("opening portal")


func _on_PortalBox_body_entered(body):
	if body.name == "Astronaut" and portal_opened:
		get_parent().get_parent().next_level()
