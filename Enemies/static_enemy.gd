extends KinematicBody2D


const MAX_HEALTH = 20 # to be reset
var health = MAX_HEALTH

var damage = 5 # to be reset

func take_damage(damage):
	health -= damage
	# play animation
