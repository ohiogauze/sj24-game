extends State
## Shows introduction of room.

const UseableScript = preload("res://classes/interactive/useable.gd")

var first_entry = true

func enter() -> void:
	var house: House = host

	house.hud.state_machine.swap("Blank")
	house.player.state_machine.swap("Frozen")

	if first_entry:
		await get_tree().create_timer(1.0).timeout

		var useable = Area3D.new()
		useable.set_script(UseableScript)
		useable.logic_id = "scr_loop_start"
		state_machine.push("Conversation", {
			"conversation_display": house.conversation_display,
			"useable": useable,
		})
		first_entry = false
		return

	host.bgm.play()
	house.curtain.open()
	await house.curtain.drawn
	ProgressManager.start_loop()
	state_machine.swap("Movement")