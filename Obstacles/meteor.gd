extends Area2D


var damage = 10 # to be replaced
var actual_speed
var speed = 0 # to be replaced
var unit_direction = Vector2(-3.0/5, 4.0/5) # to be replaced


func _physics_process(delta):
	position += actual_speed * unit_direction


func start():
	actual_speed = 2


func _on_body_entered(body):
	if body.name == "Astronaut":
		body.take_damage(damage)
