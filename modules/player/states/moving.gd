extends State
## Player is moving around.

func enter():
	var player: Player = host
	player.controllers.camera.paused = false
	player.controllers.camera.camera.make_current()
	player.controllers.movement.accepting_input = true
	player.controllers.useables.paused = false
