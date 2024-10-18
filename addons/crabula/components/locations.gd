@tool
extends VBoxContainer


func _ready():
	custom_minimum_size.x = 250.0 * EditorInterface.get_editor_scale()
