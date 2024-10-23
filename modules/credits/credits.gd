extends Control


func _ready() -> void:
	$Screens.current_tab = 0
	for screen in $Screens.get_children():
		await get_tree().create_timer(3.0).timeout

		if $Screens.current_tab == 4:
			$BGM.stop()
			$Accent.play()

		$Screens.current_tab += 1

	get_tree().change_scene_to_file("res://modules/main_menu/main_menu.tscn")