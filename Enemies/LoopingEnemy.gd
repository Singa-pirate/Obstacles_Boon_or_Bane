extends PathFollow2D


func _process(delta):
	# parent of parent is level xxx
	# range: (0, 1)
	progress_ratio += get_parent().get_parent().enemy_moving_rate 
