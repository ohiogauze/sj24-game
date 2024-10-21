extends Node
## Entrypoint for the game.

func _ready() -> void:
	## Take us straight to the main menu.
	get_tree().change_scene_to_file("res://modules/main_menu/main_menu.tscn")