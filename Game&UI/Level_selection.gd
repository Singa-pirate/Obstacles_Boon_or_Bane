extends Node2D


# Declare member variables here. Examples:
var UNIT_HORIZONTAL = 100
var UNIT_VERTICAL = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level1Button.text = "1"
	$Level2Button.text = "2"
	
	$Level1Button.rect_position += Vector2(UNIT_HORIZONTAL, UNIT_VERTICAL)
	$Level2Button.rect_position += Vector2(UNIT_HORIZONTAL * 2, UNIT_VERTICAL)


func _on_Level1Button_pressed():
	get_parent().start_level(1)

func _on_Level2Button_pressed():
	get_parent().start_level(2)
