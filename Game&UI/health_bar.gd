extends ProgressBar


var object


func _process(delta):
	if weakref(object).get_ref():
		value = object.health / object.MAX_HEALTH * 100
