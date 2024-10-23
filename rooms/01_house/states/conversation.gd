extends State
## In a conversation.


@onready var consume_move_beep: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var dialogue_start: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var dialogue_progress: AudioStreamPlayer = AudioStreamPlayer.new()

var brain: ConversationBrain


func _ready():
	consume_move_beep.stream = load("res://assets/sfx/move_spend.wav")
	dialogue_start.stream = load("res://assets/sfx/dialogue_start.wav")
	dialogue_progress.stream = load("res://assets/sfx/dialogue_progress.wav")


func enter():
	var house: House = host
	house.hud.state_machine.swap("Blank")
	house.player.state_machine.swap("Frozen")

	dialogue_start.play()
	brain.next()


func setup(data):
	get_tree().root.add_child(consume_move_beep)
	get_tree().root.add_child(dialogue_start)
	get_tree().root.add_child(dialogue_progress)

	var useable: Useable = data.useable
	brain = ConversationBrain.new(useable)

	brain.spoke.connect(func (id, speaker):
		if not dialogue_start.playing:
			dialogue_progress.play()

		data.conversation_display.display(id, speaker)
		data.conversation_display.next_requested.connect(brain.next, CONNECT_ONE_SHOT)
	)
	brain.ended.connect(func ():
		dialogue_start.stop()
		data.conversation_display.reset()

		if not useable.logic_id.begins_with("scr_"):
			ProgressManager.consume_move()

		if ProgressManager.moves_left > 0 or useable.logic_id.begins_with("scr_"):
			state_machine.pop()
	)
