extends Node2D


var astronaut_direction = Vector2.DOWN


func _ready():
	$Indicator.rotation_degrees = rad2deg(Vector2.RIGHT.angle_to(astronaut_direction))
	$Constant2Directions.unit_direction = Vector2.UP
	$Constant2Directions.unit_direction2 = Vector2.DOWN
