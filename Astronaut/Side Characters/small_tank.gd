extends CharacterBody2D


var MAX_HEALTH = 40
var health = MAX_HEALTH


func _process(delta):
	if health <= 0:
		die()


func die():
	queue_free()


func take_damage(damage):
	health -= damage
