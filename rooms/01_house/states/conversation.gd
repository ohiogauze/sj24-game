extends State
## In a conversation.


func enter():
	var house: House = host
	house.hud.state_machine.swap("Blank")
	house.player.state_machine.swap("Frozen")


func setup(data):
	var useable: Useable = data.useable
	var brain: ConversationBrain = ConversationBrain.new(useable)

	brain.spoke.connect(func (id, speaker):
		data.conversation_display.display(id, speaker)
		data.conversation_display.next_requested.connect(brain.next, CONNECT_ONE_SHOT)
	)
	brain.ended.connect(func ():
		data.conversation_display.reset()
		ProgressManager.consume_move()

		if ProgressManager.moves_left > 0:
			state_machine.swap("Movement")
	)

	brain.next()