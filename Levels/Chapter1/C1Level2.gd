extends Node2D


var astronaut_direction = Vector2.DOWN

func _ready():
	$Constant2Directions.unit_direction = Vector2.UP
	$Constant2Directions.unit_direction2 = Vector2.DOWN
