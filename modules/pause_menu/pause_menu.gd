extends Control
## Menu shown on main screen and when paused.


## Black curtain.
@onready var curtain: Curtain = $Curtain
## Fullscreen button.
@onready var fullscreen: CheckButton = $VBoxContainer/VBoxContainer/Fullscreen
## Start button.
@onready var start: Button = $VBoxContainer/VBoxContainer/Start

@onready var is_standalone := get_parent() is not TabContainer

signal button_pressed
signal closed


func _ready() -> void:
	if is_standalone:
		start.text = "Continue"
	else:
		curtain.transition_time = 3.0

func _on_quit_pressed() -> void:
	button_pressed.emit()
	curtain.close()
	await curtain.drawn
	get_tree().quit()

func _on_start_pressed() -> void:
	button_pressed.emit()

	if is_standalone:
		closed.emit()
		return

	curtain.close()
	await curtain.drawn
	get_tree().change_scene_to_file("res://rooms/01_house/01_house.tscn")

func _on_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen.button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)
