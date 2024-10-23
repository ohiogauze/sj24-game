extends State
## Failure state.

var first_entry := true
const UseableScript = preload("res://classes/interactive/useable.gd")


func enter():
	var house: House = host

	if first_entry:
		house.bgm.stop()
		house.player.state_machine.push("Frozen")

		await get_tree().create_timer(2.0).timeout
		house.curtain.close()
		await house.curtain.drawn

		house.hud.state_machine.push("Blank")

		var we: WorldEnvironment = house.get_node("WorldEnvironment")
		we.environment.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED
		for light in house.get_node("Lights").get_children():
			light.queue_free()
		house.get_node("Static").play()
		var fm = house.get_node("FailureModels")
		fm.show()
		fm.get_node("Camera3D").make_current()
		house.curtain.open()
		await house.curtain.drawn

		# Start useable
		var useable = Area3D.new()
		useable.set_script(UseableScript)
		useable.logic_id = "scr_loop_end"
		state_machine.push("Conversation", {
			"conversation_display": house.conversation_display,
			"useable": useable,
		})

		first_entry = false
		return

	house.get_node("Static").stop()
	house.get_node("Stab").play()
	await get_tree().create_timer(0.2).timeout
	house.get_node("Red").show()
	
	await get_tree().create_timer(2.0).timeout
	house.curtain.close()
	await house.curtain.drawn

	ProgressManager.true_end_loop()