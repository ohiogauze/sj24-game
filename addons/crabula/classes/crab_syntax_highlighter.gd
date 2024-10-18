@tool
extends CodeHighlighter
## Highlights CrabScript correctly.

func _init():
	for keyword in ["has", "end", "check", "else"]:
		add_keyword_color(keyword, Color.MEDIUM_PURPLE)

	for keyword in ["set", "give", "take", "goto", "exit"]:
		add_keyword_color(keyword, Color.LIME_GREEN)

	symbol_color = Color.AQUA

