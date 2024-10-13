extends State
## Player is not moving at all.

func enter():
	var player: Player = host
	player.controllers.camera.paused = true
	player.controllers.movement.accepting_input = false
	player.controllers.useables.paused = true
