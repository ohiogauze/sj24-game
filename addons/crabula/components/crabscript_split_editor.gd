@tool
class_name CrabscriptSplitEditor
extends HBoxContainer


@onready var input: CrabscriptInput = $CrabscriptInput
@onready var visualiser: CrabscriptVisualiser = $CrabscriptVisualiser

signal text_set(text: String)

const TIMEOUT := .5
var speaker: String
var timer: SceneTreeTimer


func _ready():
	_on_text_changed()


func _on_text_changed() -> void:
	if timer:
		timer.time_left = TIMEOUT
	else:
		timer = get_tree().create_timer(TIMEOUT)
		await timer.timeout
		var data = CrabCompiler.build(input.text, speaker)
		visualiser.display(data)
		text_set.emit(input.text)
		timer = null


func set_text(text: String):
	input.text = text
	_on_text_changed()
