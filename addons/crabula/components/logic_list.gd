@tool
class_name LogicList
extends Tree

signal changed(item: LogicItem)

const LOGIC_JSON_PATH = "res://data/logic.json"

var root := create_item()

func _ready():
	rebuild()
	custom_minimum_size.x = 200.0 * EditorInterface.get_editor_scale()

func _exit_tree():
	for child in root.get_children():
		root.remove_child(child)


func add_new(id: String):
	var useable = LogicItem.new({
		"id": id,
		"lines": [],
	})

	var item = create_item(root)
	item.set_metadata(0, useable)
	item.set_text(0, useable.id)
	
	resave()
	rebuild()


func remove_selected():
	var item = get_selected()
	if item:
		root.remove_child(item)
	var child = root.get_child(0)
	if child:
		set_selected(child, 0)
	resave()


func rebuild():
	for child in root.get_children():
		root.remove_child(child)

	var file = FileAccess.get_file_as_string(LOGIC_JSON_PATH)
	print(file)
	var useables = JSON.parse_string(file)
	useables.sort_custom(func (a, b):
		return a.id < b.id)
	useables = useables.map(func (line: Dictionary):
		var item = LogicItem.new(line)
		item.changed.connect(resave)
		return item)

	var first_item = true
	for useable in useables:
		var item = create_item(root)
		item.set_metadata(0, useable)
		item.set_text(0, useable.id)

		if first_item:
			item.select(0)
			first_item = false


func resave():
	var file = FileAccess.open(LOGIC_JSON_PATH, FileAccess.WRITE)
	var lines = root.get_children()\
		.map(func (item: TreeItem):
		return item.get_metadata(0).pack())
	file.store_string(JSON.stringify(lines))


func _on_item_selected() -> void:
	changed.emit(get_selected().get_metadata(0))
