extends Node2D


var astronaut_direction = Vector2.RIGHT
var small_tank_count = 6


func _ready():
	$Constant2Directions.unit_direction = Vector2(-4, 2.5).normalized()
	$Constant2Directions.unit_direction2 = Vector2(4, -2.5).normalized()
	$Constant2Directions2.unit_direction = Vector2(5, 2).normalized()
	$Constant2Directions2.unit_direction2 = Vector2(-5, -2).normalized()
	$Constant2Directions.bullet_damage = 10
	$Constant2Directions2.bullet_damage = 10
	$Astronaut.wormhole_available = true
	$Astronaut.health_regen_available = true
