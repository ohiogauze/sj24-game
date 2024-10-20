class_name ConversationDisplay
extends Node
## Manages both text and camera of conversations.

## Audio player which beeps when text is added.
@onready var beeper: AudioStreamPlayer = $Beeper
## Button which can be clicked to progress dialogue.
@onready var clicker: Button = $Clicker
## Container holding the message and speaker labels.
@onready var dialogue: Control = $Dialogue
## Label displaying the current message.
@onready var message: Label = $Dialogue/VBoxContainer/Message
## Label displaying the name of the current speaker.
@onready var speaker: Label = $Dialogue/VBoxContainer/Speaker
## Marks that a conversation can continue.
@onready var continue_marker: Control = $Dialogue/ContinueMarker

signal next_requested

## Whether we can continue to the next line of dialogue.
var finished_scrolling : get = _get_finished_scrolling
## When the last beep was played.
var last_beep_time := 0.0

const SCROLL_SPEED := 69.420
const MS_BETWEEN_BEEPS := 69.420


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	if dialogue.visible and not finished_scrolling:
		if Time.get_ticks_msec() - last_beep_time >= MS_BETWEEN_BEEPS:
			last_beep_time = Time.get_ticks_msec()
			beeper.pitch_scale = 0.96 + 0.08 * randf()
			beeper.play()
		message.visible_ratio += (SCROLL_SPEED / message.text.length()) * delta

	continue_marker.visible = dialogue.visible and finished_scrolling
	continue_marker.modulate.a = sin(Time.get_ticks_msec() * .005) * .15 + .85


func _get_finished_scrolling() -> bool:
	return message.visible_ratio >= 1.0


func _on_clicker_pressed() -> void:
	if not finished_scrolling:
		message.visible_characters = message.text.length()
		return

	next_requested.emit()


func display(speaker_name: String, message_text: String):
	finished_scrolling = false

	dialogue.show()
	clicker.show()

	speaker.text = speaker_name
	message.text = message_text

	message.visible_ratio = 0.0


func reset():
	dialogue.hide()
	clicker.hide()
