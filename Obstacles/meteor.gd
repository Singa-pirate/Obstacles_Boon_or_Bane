extends Area2D


var damage = 10 # to be replaced
var speed = 0 # to be replaced
var unit_direction = Vector2(-3.0/5, 4.0/5) # to be replaced


func _physics_process(delta):
	position += speed * unit_direction


func start():
	speed = 2


func get_class():
	return "meteor"


func _on_Meteor_body_entered(body):
	if body.name == "Astronaut":
		body.take_damage(damage)
