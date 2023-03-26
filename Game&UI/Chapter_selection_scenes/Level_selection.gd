extends Node2D


# UI graphic
var UNIT_HORIZONTAL = 100
var UNIT_VERTICAL = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level1Button.text = "1"
	$Level2Button.text = "2"
	$Level3Button.text = "3"
	$Level4Button.text = "4"
	$Level5Button.text = "5"
	
	$Level1Button.position += Vector2(UNIT_HORIZONTAL, UNIT_VERTICAL)
	$Level2Button.position += Vector2(UNIT_HORIZONTAL * 2, UNIT_VERTICAL)
	$Level3Button.position += Vector2(UNIT_HORIZONTAL * 3, UNIT_VERTICAL)
	$Level4Button.position += Vector2(UNIT_HORIZONTAL * 4, UNIT_VERTICAL)
	$Level5Button.position += Vector2(UNIT_HORIZONTAL * 5, UNIT_VERTICAL)
	$PrevChapButton.position += Vector2(UNIT_HORIZONTAL * 2, UNIT_VERTICAL * 4)
	$NextChapButton.position += Vector2(UNIT_HORIZONTAL * 3, UNIT_VERTICAL * 4)
	$Label.position += Vector2(UNIT_HORIZONTAL * 2, UNIT_VERTICAL * 6)

func _on_Level1Button_pressed():
	get_parent().start_level(1)

func _on_Level2Button_pressed():
	get_parent().start_level(2)

func _on_Level3Button_pressed():
	get_parent().start_level(3)

func _on_level_4_button_pressed():
	get_parent().start_level(4)

func _on_level_5_button_pressed():
	get_parent().start_level(5)
