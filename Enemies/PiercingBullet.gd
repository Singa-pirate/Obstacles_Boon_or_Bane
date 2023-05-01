extends Area2D


var damage
var direction
const speed = 16


func _ready():
	$AnimatedSprite2D.play()
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(direction))


func _process(delta):
	position += direction * speed


func _on_body_entered(body):
	if body.is_in_group("Character"):
		body.take_damage(damage)
