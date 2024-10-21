extends State
## Allows movement throughout room.

func enter() -> void:
	var house: House = host
	house.hud.state_machine.swap("Movement")
	house.player.state_machine.swap("Moving")


func on_process(_delta: float):
	if Input.is_action_just_pressed("pause"):
		state_machine.push("Pause")