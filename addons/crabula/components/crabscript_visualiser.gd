@tool
class_name CrabscriptVisualiser
extends ScrollContainer
## Displays compiled Crabscript in view.

@onready var list: VBoxContainer = $List


func display(data: Array):
	# Clear list.
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()

	var first_label = Label.new()
	first_label.text = "<=> BLOCK: \"default\" <=>"
	var indentation = 1
	list.add_child(first_label)

	for item in data:
		var label := Label.new()
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var current_indentation = indentation

		match item.type:
			# Block
			"block":
				current_indentation = 0
				label.text = "<=> BLOCK: \"%s\" <=>" % item.name
				indentation = 1

			# Speech
			"speech":
				label.text = "%s says: \"%s\"" % [item.speaker, item.message]

			# Commands
			"set":
				var action = "Clears" if item.is_negated else "Sets"
				label.text = "%s flag \"%s\"" % [action, item.flag]

			"give":
				label.text = "Player rids themselves of \"%s\"" % item.item

			"take":
				label.text = "Player acquires \"%s\"" % item.item

			# Takes us to another conversation.
			"goto":
				label.text = "Jump to block: \"%s\"" % item.target

			# Exits the conversation immediately.
			"exit":
				label.text = "Conversation ends abruptly"

			# Increases the conversation counter.
			"accumulate":
				label.text = "Increase the conversation count by 1"

			# Activates the Useable.
			"activate":
				label.text = "Activate Useable with ID of \"%s\"" % item.id

			# Opens the door.
			"open":
				label.text = "Opens Door with name of \"%s\"" % item.door


			# Specific controls
			"check":
				var action = "not set" if item.is_negated else "set"
				label.text = "if flag \"%s\" is %s" % [item.flag, action]
				indentation += 1

			"count":
				print(item)
				var action = "is at least" if item.at_least else "is"
				label.text = "check if conversation count %s \"%s\"" % [action, item.value]
				indentation += 1

			"has":
				var action = "doesn't have" if item.is_negated else "has"
				label.text = "if Player %s \"%s\" in inventory" % [action, item.item]
				indentation += 1


			# Generic controls
			"else":
				label.text = "otherwise..."
				current_indentation -= 1

			"end":
				label.text = "end block"
				indentation -= 1
				current_indentation -= 1

			"error":
				label.text = "ERROR: %s " % item.message

		label.text = "   ".repeat(current_indentation) + label.text
		list.add_child(label)
