@tool
class_name CrabscriptTemplateSelector
extends MenuButton
## Allows user to pick a Crabscript template for the current conversation.

@export_node_path("CrabscriptSplitEditor") var editor_path

var template_values = {
	"id": "test",
}

const DEFAULT_TEMPLATE = [
	":check {id}_selected",
    "	:goto follow_up",
	":end",
	"",
	":goto intro",
	"",
	"::intro",
	"Example intro text",
	":set {id}_selected",
	"",
	"::follow_up",
	"Example follow up text",
]


func _ready() -> void:
	get_popup().id_pressed.connect(on_select)


func on_select(id: int):
	var editor = get_node(editor_path)

	match id:
		0:
			editor.set_text("\n".join(DEFAULT_TEMPLATE).format({
				"id": template_values.id,
			}))