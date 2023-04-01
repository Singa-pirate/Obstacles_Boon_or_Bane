extends StaticBody2D


var portal_opened = false

func _process(delta):
	if not portal_opened and get_parent().get_parent().no_alive_enemy():
		open_portal()


func open_portal():
	portal_opened = true
	#$AnimatedSprite2D.animation = "open"
	$AnimatedSprite2D.play("open")


func _on_PortalBox_body_entered(body):
	if body.name == "Astronaut" and portal_opened:
		portal_opened = false
		body.enter_portal()
		get_parent().get_parent().level_passed()
