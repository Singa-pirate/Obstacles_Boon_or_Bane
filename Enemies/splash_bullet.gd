extends Area2D


var target_position
var SPEED = 6
var error_margin = 3
var damage


func _physics_process(delta):
	position += (target_position - position).normalized() * SPEED
	if (position - target_position).length() < error_margin:
		inflict_damage()


func inflict_damage():
	for body in get_overlapping_bodies():
		if body.is_in_group("Character"):
			body.take_damage(damage)
	queue_free()
