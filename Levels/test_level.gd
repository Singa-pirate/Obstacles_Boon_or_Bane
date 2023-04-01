extends Node


var astronaut_direction = Vector2.RIGHT
var small_tank_count = 5


func _ready():
	$Indicator.rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(astronaut_direction))
	$Astronaut.wormhole_available = true
