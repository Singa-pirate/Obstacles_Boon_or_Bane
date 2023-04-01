extends PathFollow2D


func _process(delta):
	# parent of parent is LevelX.tscn
	# range: (0, 1)
	progress_ratio += get_parent().get_parent().enemy_moving_rate 
