extends PathFollow2D

func _process(delta):
	progress_ratio += get_parent().get_parent().meteor_moving_rate
