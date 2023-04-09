extends CharacterBody2D


var damage = 3
var speed = 0.5

var target

var MAX_HEALTH = 10
var health = MAX_HEALTH


func _process(delta):
	if target != null:
		velocity = (target.position - position).normalized() * speed
		move_and_slide()
	
	if health <= 0:
		die()


func die():
	queue_free()


func take_damage(damage):
	health -= damage


func get_nearest_character():
	var distance
	var nearest_character = null
	for body in $TargetArea.get_overlapping_bodies():
		if body.is_in_group("Character"):
			var this_distance = (position - body.global_position).length()
			if nearest_character == null:
				nearest_character = body
				distance = this_distance
			elif this_distance < distance:
				nearest_character = body
				distance = this_distance
	return nearest_character


func _on_target_area_body_entered(body):
	if body.is_in_group("Character") and (!weakref(target).get_ref() or target == null):
		target = body


func _on_target_area_body_exited(body):
	if body == target:
		target = get_nearest_character()
