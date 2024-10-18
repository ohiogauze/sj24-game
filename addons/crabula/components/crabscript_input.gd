@tool
class_name CrabscriptInput
extends CodeEdit

var CrabSyntaxHighlighter := preload("../classes/crab_syntax_highlighter.gd")


func _ready():
	syntax_highlighter = CrabSyntaxHighlighter.new()
