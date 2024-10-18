@tool
extends ConfirmationDialog


signal added(text: String)

var text_edit_path = "NewLabel"


func _ready() -> void:
    hide()

    if has_node(text_edit_path):
        var text_edit: LineEdit = get_node(text_edit_path)
        text_edit.text_changed.connect(func (text):
            print("Edited")
            get_ok_button().disabled = text.strip_edges() == "")
        confirmed.connect(func ():
            added.emit(text_edit.text))


func open():
    if has_node(text_edit_path):
        var text_edit: LineEdit = get_node(text_edit_path)
        text_edit.text = ""
        text_edit.grab_click_focus()
        get_ok_button().disabled = true
        show()