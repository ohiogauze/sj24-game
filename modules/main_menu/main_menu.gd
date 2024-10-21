extends Control
## Displays all intro screens, ending in the main menu._active_tween


## Black curtain.
@onready var curtain: Curtain = $Curtain
## All screens to display.
@onready var screens: TabContainer = $Screens


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout

	for screen in screens.get_children():
		screens.current_tab = screen.get_index()

		curtain.open()
		await curtain.drawn

		await get_tree().create_timer(2.0).timeout

		if screens.current_tab != screens.get_children().size() - 1:
			curtain.close()
			await curtain.drawn
			await get_tree().create_timer(0.5).timeout