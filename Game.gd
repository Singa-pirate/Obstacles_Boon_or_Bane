extends Node

var Level2 = preload("res://Level2.tscn")
var level2

# Go to the level_num level
func next_level():
	get_node("Level1").queue_free()
	level2 = Level2.instance()
	add_child(level2)
