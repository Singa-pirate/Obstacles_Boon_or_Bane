extends Node2D


var astronaut_direction = Vector2.RIGHT

const Meteor = preload("res://Obstacles/Meteor.tscn")
var left_meteor_show = 700
var right_meteor_show = 1000
var upper_meteor_show = 0
var meteor_direction = Vector2.DOWN
var meteor_speed = 10
var rng = RandomNumberGenerator.new()


func _ready():
	$Static1.damage = 12
	$Static2.damage = 12
	$Static3.damage = 12
	$Static4.damage = 12
	$Static5.damage = 12
	$Static6.damage = 30
	$Static7.damage = 30
	$Static8.damage = 30
	$AutoFocus.bullet_damage = 100
	$Astronaut.health_regen_available = true


func new_meteor():
	var meteor = Meteor.instantiate()
	meteor.position = Vector2(rng.randi_range(left_meteor_show, right_meteor_show), upper_meteor_show)
	meteor.unit_direction = meteor_direction
	meteor.speed_after_start = meteor_speed
	add_child(meteor)
	meteor.start()


func _on_meteor_timer_1_timeout():
	new_meteor()


func _on_timer_2_starter_timeout():
	$MeteorTimer2.start()


func _on_meteor_timer_2_timeout():
	new_meteor()
