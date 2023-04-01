extends Area2D


var strength = 0.05 # to be modified
var charge = 15
var damage = 100


func _on_hit_box_body_entered(body):
	if body.name == "Astronaut" or body.is_in_group("Enemies") or body.is_in_group("Meteor") or body.is_in_group("Bullet"):
		body.die()
