extends KinematicBody2D


const MAX_HEALTH = 20 # to be reset
var health = MAX_HEALTH

var damage = 5 # to be reset

# movement
var original_pos
var target = null
const minimum_distance = 10
const ratio = 1/20
const minimum_distance_to_origin = 2

# bullet
const Bullet = preload("res://Enemies/SingleTarget.tscn")


func _ready():
	original_pos = position


func _physics_process(delta):
	# movement
	if target != null:
		var curr_distance = (target.position - position).length()
		if curr_distance > minimum_distance:
			move_and_slide((target.position - position) * ratio)
	else:
		var curr_distance = (position - original_pos).length()
		if curr_distance > minimum_distance_to_origin:
			move_and_slide((original_pos - position) * ratio)
	
	if health <= 0:
		die()


func take_damage(damage):
	health -= damage
	# play animation


func die():
	queue_free()


func get_nearest_character():
	var distance
	var nearest_character = null
	for body in $TargetArea.get_overlapping_bodies():
		if body.is_in_group("Character"):
			var this_distance = (position - body.position).length()
			if nearest_character == null:
				nearest_character = body
				distance = this_distance
			elif this_distance < distance:
				nearest_character = body
				distance = this_distance
	return nearest_character


func _on_TargetArea_body_entered(body):
	if body.is_in_group("Character") and target == null:
		target = body


func _on_TargetArea_body_exited(body):
	if body == target:
		target = get_nearest_character()


func _on_BulletTimer_timeout():
	if target != null:
		var bullet = Bullet.instance()
		bullet.target = target
		bullet.position = position
		get_parent().add_child(bullet)
