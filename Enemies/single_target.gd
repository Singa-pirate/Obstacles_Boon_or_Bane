extends Area2D


var DAMAGE = 15 # to be changed

const SPEED = 5

var target
var target_position # to be used when target disappears
var error_margin = 4


func _physics_process(delta):
	if (weakref(target) and target.get_collision_layer_value(1)):
		position += SPEED * (target.position - position).normalized()
		target_position = target.position
		rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(target.position - position))
	else:
		position += SPEED * (target_position - position).normalized()
		rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(target_position - position))
		if (position - target_position).length() < 4:
			queue_free()


func _on_SingleTarget_body_entered(body):
	if body == target:
		body.take_damage(DAMAGE)
		queue_free()
