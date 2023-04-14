extends Node2D


var astronaut_direction = Vector2.RIGHT


func _ready():
	$Astronaut.health_regen_available = true
