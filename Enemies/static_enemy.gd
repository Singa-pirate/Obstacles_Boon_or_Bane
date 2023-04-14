extends CharacterBody2D


const MAX_HEALTH = 25 # to be reset
var health = MAX_HEALTH

var damage = 5 # to be reset


func _process(delta):
	if health <= 0:
		die()


func take_damage(damage):
	health -= damage
	# play animation


func die():
	queue_free()
