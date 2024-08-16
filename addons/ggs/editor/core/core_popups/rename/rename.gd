@tool
extends ConfirmationDialog

enum RenameMode {NONE, CATEGORY, GROUP, SETTING}

const TITLE_BASE: String = "Rename "

var rename_mode: RenameMode = RenameMode.NONE

@export_group("Nodes")
@export var CurField: LineEdit
@export var NewField: LineEdit


func _ready() -> void:
	get_ok_button().pressed.connect(_on_OkBtn_pressed)
	visibility_changed.connect(_on_visibility_changed)
	GGS.Event.PopupNotif.notif_closed.connect(_on_notif_closed)
	
	GGS.Event.PopupNotif.category_rename_requested.connect(
			_on_category_rename_requested)


func _on_OkBtn_pressed() -> void:
	var prev_name: String = CurField.text
	var new_name: String = NewField.text
	var resolved_signal: Signal
	match rename_mode:
		RenameMode.CATEGORY:
			resolved_signal = GGS.Event.PopupNotif.category_rename_resolved
		RenameMode.GROUP:
			pass
		RenameMode.SETTING:
			pass
	
	if not ggsUtils.item_name_validate(new_name):
		return
	
	resolved_signal.emit(prev_name, new_name)
	hide()


func _on_visibility_changed() -> void:
	if not visible:
		return
	
	NewField.clear()
	NewField.grab_focus()


func _on_notif_closed() -> void:
	if not visible:
		return
	
	grab_focus()
	NewField.grab_focus()
	NewField.select_all()


# Category #
func _on_category_rename_requested(cat_name: String) -> void:
	title = TITLE_BASE + "Category"
	rename_mode = RenameMode.CATEGORY
	
	CurField.text = cat_name
	popup_centered()
