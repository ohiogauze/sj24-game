extends State
## Shows introduction of room.

func enter() -> void:
	var house: House = host
	house.hud.state_machine.swap("Blank")
	house.player.state_machine.swap("Frozen")

	house.curtain.open()
	await house.curtain.drawn
	ProgressManager.start_loop()
	state_machine.swap("Movement")