extends Node2D


var astronaut_direction = Vector2.RIGHT


func _ready():
	$Indicator.rotation_degrees = rad2deg(Vector2.RIGHT.angle_to(astronaut_direction))
