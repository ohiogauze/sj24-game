@tool
extends CodeHighlighter
## Highlights CrabScript correctly.

func _init():
	for keyword in ["has", "end", "check", "else", "count"]:
		add_keyword_color(keyword, Color.MEDIUM_PURPLE)

	for keyword in ["set", "give", "take", "goto", "exit", "accumulate"]:
		add_keyword_color(keyword, Color.LIME_GREEN)

	symbol_color = Color.AQUA

	# Match number colour to default text colour.
	var editor_settings := EditorInterface.get_editor_settings()
	number_color = editor_settings.get_setting("text_editor/theme/highlighting/text_color")
