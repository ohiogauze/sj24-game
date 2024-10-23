extends Control


func _ready() -> void:
	for screen in $Screens.get_children():
		$Screens.current_tab = screen.get_index()

		await get_tree().create_timer(3.0).timeout

	get_tree().change_scene_to_file("res://modules/main_menu/main_menu.tscn")