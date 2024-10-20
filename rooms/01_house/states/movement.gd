extends State
## Allows movement throughout room.

func enter() -> void:
	var house: House = host
	house.hud.state_machine.swap("Movement")
	house.player.state_machine.swap("Moving")
