extends Node2D


var astronaut_direction = Vector2.RIGHT
var small_tank_count = 3


func _ready():
	$Astronaut.wormhole_available = true
	$Astronaut.health_regen_available = true
	$PiercingEnemy.bullet_damage = 24
	$PiercingEnemy.change_gun_direction(Vector2.LEFT)
