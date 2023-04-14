extends Area2D


var damage = 10 # to be replaced
var actual_speed
var speed_before_start = 0
var speed_after_start = 10 # to be replaced
var unit_direction = Vector2(-3.0/5, 4.0/5) # to be replaced


func _ready():
	actual_speed = speed_before_start


func _physics_process(delta):
	position += actual_speed * unit_direction


func start():
	actual_speed = speed_after_start


func _on_body_entered(body):
	if body.name == "Astronaut":
		body.take_damage(damage)
