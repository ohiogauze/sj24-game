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
var is_item_dialogue := false
## When the last beep was played.
var last_beep_time := 0.0

var accent := AudioStreamPlayer.new()

const SCROLL_SPEED := 69.420
const MS_BETWEEN_BEEPS := 69.420


func _ready() -> void:
	accent.stream = load("res://assets/sfx/accent.wav")
	add_child(accent)

	reset()


func _process(delta: float) -> void:
	if dialogue.visible and not finished_scrolling:
		if Time.get_ticks_msec() - last_beep_time >= MS_BETWEEN_BEEPS and not is_item_dialogue:
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
	is_item_dialogue = message_text.contains("Acquired")

	dialogue.show()
	clicker.show()

	speaker.text = speaker_name
	message.text = message_text
	message.set("theme_override_colors/font_color", Color.YELLOW if is_item_dialogue else Color.WHITE)

	if is_item_dialogue:
		accent.play()

	message.visible_ratio = 0.0


func reset():
	dialogue.hide()
	clicker.hide()
