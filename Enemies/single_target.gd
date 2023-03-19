extends Area2D


var DAMAGE = 15 # to be changed

const SPEED = 20

var target


func _physics_process(delta):
	position += SPEED * (target.position - position).normalized()
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(target.position - position))


func _on_SingleTarget_body_entered(body):
	if body == target:
		body.take_damage(DAMAGE)
		queue_free()
