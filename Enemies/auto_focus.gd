extends CharacterBody2D


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
var bullet_damage = 50


func _ready():
	original_pos = position
	$AnimationPlayer.play("animation")


func _physics_process(delta):
	# movement
	if target != null:
		var curr_distance = (target.position - position).length()
		if curr_distance > minimum_distance:
			set_velocity((target.position - position) * ratio)
			move_and_slide()
	else:
		var curr_distance = (position - original_pos).length()
		if curr_distance > minimum_distance_to_origin:
			set_velocity((original_pos - position) * ratio)
			move_and_slide()
	
	if health <= 0:
		die()
	
	if !weakref(target).get_ref():
		target = get_nearest_character()


func take_damage(damage):
	health -= damage


func die():
	queue_free()


func get_nearest_character():
	var distance
	var nearest_character = null
	for body in $TargetArea.get_overlapping_bodies():
		if body.is_in_group("Character"):
			var this_distance = (global_position - body.global_position).length()
			if nearest_character == null:
				nearest_character = body
				distance = this_distance
			elif this_distance < distance:
				nearest_character = body
				distance = this_distance
	return nearest_character


func _on_TargetArea_body_entered(body):
	if body.is_in_group("Character") and (!weakref(target).get_ref() or target == null):
		target = body


func _on_TargetArea_body_exited(body):
	if body == target:
		target = get_nearest_character()


func _on_BulletTimer_timeout():
	if target != null:
		var bullet = Bullet.instantiate()
		bullet.target = target
		bullet.position = position
		bullet.damage = bullet_damage
		get_parent().add_child(bullet)
