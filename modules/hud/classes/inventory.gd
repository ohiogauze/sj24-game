extends HBoxContainer
## Items collected by the user.


func _ready() -> void:
	ProgressManager.items.changed.connect(rebuild)
	rebuild(ProgressManager.items.list())


func rebuild(data: Array) -> void:
	for child in get_children():
		child.queue_free()

	print("REBUILT")
	for item in data:
		var id = "key" if item.contains("key") else item
		var texture = load("res://assets/sprites/items/%s.png" % id)
		var rect = TextureRect.new()
		rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		rect.texture = texture
		rect.custom_minimum_size = Vector2(32, 32)
		add_child(rect)