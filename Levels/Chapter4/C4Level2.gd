extends Node2D


var astronaut_direction = Vector2.RIGHT
var small_tank_count = 7


func _ready():
	$Astronaut.wormhole_available = true
