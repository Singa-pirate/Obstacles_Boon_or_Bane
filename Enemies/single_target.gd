extends Area2D


var damage

const SPEED = 5

var target
var target_position # to be used when target disappears
var error_margin = 4


func _physics_process(delta):
	if (weakref(target).get_ref() and target.get_collision_layer_value(1)):
		position += SPEED * (target.global_position - position).normalized()
		target_position = target.global_position
		rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(target.global_position - position))
	else:
		position += SPEED * (target_position - position).normalized()
		rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(target_position - position))
	if (position - target_position).length() < 4:
		queue_free()


func _on_SingleTarget_body_entered(body):
	if body == target:
		body.take_damage(damage)
		queue_free()
