extends ProgressBar


var object
var enemy

func _process(delta):
	if weakref(object).get_ref():
		value = object.health * 100 / object.MAX_HEALTH
