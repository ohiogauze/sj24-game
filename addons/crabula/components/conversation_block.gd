@tool
class_name ConversationBlock
extends HBoxContainer

const CHARACTER_PATH = "PanelContainer/VBoxContainer/Character"

@export var is_traveller := false

func _ready():
	update_alignment()
	$PanelContainer.custom_minimum_size.x = 400 * EditorInterface.get_editor_scale()

func _process(delta: float) -> void:
	update_alignment()

	if not has_node(CHARACTER_PATH):
		return

	var character: Label = get_node(CHARACTER_PATH)
	var index := get_index()

	if index == 0:
		character.show()
		return

	if get_parent().get_child(index - 1).is_traveller == is_traveller:
		character.hide()
	else:
		character.show()


func update_alignment():
	alignment = BoxContainer.ALIGNMENT_END if is_traveller else BoxContainer.ALIGNMENT_BEGIN
