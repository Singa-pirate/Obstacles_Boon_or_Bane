extends Node2D


# UI graphic
var UNIT_HORIZONTAL = 100
var UNIT_VERTICAL = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Level1ButtonSprite.position += Vector2(UNIT_HORIZONTAL * 2, UNIT_VERTICAL * 6)
	$Level2ButtonSprite.position += Vector2(UNIT_HORIZONTAL * 4, UNIT_VERTICAL * 5)
	$Level3ButtonSprite.position += Vector2(UNIT_HORIZONTAL * 6, UNIT_VERTICAL * 6)
	$Level4ButtonSprite.position += Vector2(UNIT_HORIZONTAL * 8, UNIT_VERTICAL * 5)
	$Level5ButtonSprite.position += Vector2(UNIT_HORIZONTAL * 10, UNIT_VERTICAL * 6)
	$PrevChapButton.position += Vector2(UNIT_HORIZONTAL * 5, UNIT_VERTICAL * 10)
	$NextChapButton.position += Vector2(UNIT_HORIZONTAL * 6, UNIT_VERTICAL * 10)
	$Label.position += Vector2(UNIT_HORIZONTAL * 5, UNIT_VERTICAL)

func _on_level_1_button_pressed():
	get_parent().start_level(1)

func _on_level_2_button_pressed():
	get_parent().start_level(2)

func _on_level_3_button_pressed():
	get_parent().start_level(3)

func _on_level_4_button_pressed():
	get_parent().start_level(4)

func _on_level_5_button_pressed():
	get_parent().start_level(5)
