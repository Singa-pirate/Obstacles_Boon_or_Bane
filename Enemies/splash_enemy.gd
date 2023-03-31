extends CharacterBody2D


const MAX_HEALTH = 20
var health = MAX_HEALTH

const Bullet = preload("res://Enemies/SplashBullet.tscn")


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


func _on_timer_timeout():
	var nearest_character = get_nearest_character()
	if nearest_character != null:
		var bullet = Bullet.instantiate()
		bullet.position = position
		bullet.target_position = nearest_character.position
		get_parent().add_child(bullet)
