@tool
class_name TimelineView
extends HBoxContainer
## Displays all times and associated data.


@onready var logic_list: LogicList = $Useables/LogicList

var template_selector_path = "VBoxContainer/HBoxContainer/Conversations/Toolbar/HBoxContainer/TemplateSelector"


func _on_times_list_changed(useable: LogicItem) -> void:
	call_deferred("load_conversation")


func load_conversation(id = "") -> void:
	var editor_path = "VBoxContainer/HBoxContainer/Conversations/CrabscriptSplitEditor"
	var editing_path = "VBoxContainer/HBoxContainer/Conversations/HBoxContainer/Editing"
	if has_node(editor_path) and has_node(editing_path):
		var useable: LogicItem = logic_list.get_selected().get_metadata(0)
		var editor: CrabscriptSplitEditor = get_node(editor_path)
		var editing: Label = get_node(editing_path)

		editor.speaker = id
		editor.set_text("\n".join(useable.lines))
		editing.text = "Editing %s" % useable.id

		if has_node(template_selector_path):
			var template_selector = get_node(template_selector_path)
			template_selector.template_values = {
				"id": useable.id
			}


func _on_conversation_edited(lines: String) -> void:
	print(lines)
	var useable: LogicItem = logic_list.get_selected().get_metadata(0)
	useable.set_lines(lines.split("\n"))