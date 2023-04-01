extends Node2D


var astronaut_direction = Vector2(1,3).normalized()

func _ready():
	$ConstantDirection.unit_direction = Vector2(1,3).normalized()
