@tool
extends EditorPlugin

const Crabula = preload("./crabula.tscn")

var main_view: Control

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		return

	add_autoload_singleton("CharacterStore", "res://addons/crabula/autoloads/character_store.gd")

	Engine.set_meta("CrabulaPlugin", self)

	main_view = Crabula.instantiate()
	main_view.editor_plugin = self
	get_editor_interface().get_editor_main_screen().add_child(main_view)
	_make_visible(false)

func _exit_tree() -> void:
	if is_instance_valid(main_view):
		main_view.queue_free()

	Engine.remove_meta("CrabulaPlugin")

	remove_autoload_singleton("CharacterStore")

func _make_visible(next_visible: bool) -> void:
	if is_instance_valid(main_view):
		main_view.visible = next_visible

## Plugin setup.

func _has_main_screen() -> bool:
	return true

func _get_plugin_icon() -> Texture2D:
	return load("res://addons/crabula/icons/character.svg")

func _get_plugin_name() -> String:
	return "Logic"
