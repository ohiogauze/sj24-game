@tool
extends Node
## Loads all characters and holds them for the game.

## When the list of characters has been reloaded.
signal reloaded

## Directory in which all .npc.json files will live.
const PATH = "res://data/characters/"

## All characters in the game.
var data: Array = []

var last_exec_time: float = 0.00

# func _ready():
# 	reload()

# 	if Engine.is_editor_hint():
# 		EditorInterface.get_resource_filesystem().filesystem_changed.connect(reload)
# 		EditorInterface.get_resource_filesystem().sources_changed.connect(_on_sources_changed)

# ## Finds a character by ID.
# func get_by_id(id: String) -> CharacterStruct:
# 	for character in data:
# 		if character.id == id:
# 			return character

# 	return null

# ## Loads all characters into memory.
# func reload():
# 	var current_time = Time.get_unix_time_from_system()
# 	if (current_time - last_exec_time) < 100.0:
# 		return

# 	last_exec_time = current_time

# 	# Blank all characters to prepare for loading.
# 	data = []

# 	# Iterate through all character files.
# 	var dir = DirAccess.open(PATH)
# 	for file in dir.get_files():
# 		if not file.ends_with(".npc.json"):
# 			continue

# 		# Parse JSON and throw into character pile.
# 		var access = FileAccess.open(PATH + file, FileAccess.READ)
# 		var content = JSON.parse_string(access.get_as_text())
# 		data.append(CharacterStruct.new(content))
# 		access.close()

# 	reloaded.emit()

# func update(data) -> void:
# 	get_by_id(data.id).update(data)
# 	reloaded.emit()

# func _on_sources_changed(_exist: bool) -> void:
# 	reload()
