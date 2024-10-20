extends State
## For when moving around.


func enter():
	var hud: HUD = host
	hud.show()

	hud.loop_counter.get_node("Count").text = str(ProgressManager.current_loop)
	hud.set_moves_left(ProgressManager.moves_left)