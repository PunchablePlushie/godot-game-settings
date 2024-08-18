@tool
extends AcceptDialog

@export_subgroup("Title", "title_")
@export var title_name_invalid: String
@export var title_name_exists: String

@export_subgroup("Text", "text_")
@export_multiline var text_name_invalid: String
@export_multiline var text_name_exists: String

var _notif_type: ggsCore.NotifType


func _init() -> void:
	visible = false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	GGS.Event.notif_requested.connect(_on_Global_notif_requested)


func _set_content() -> void:
	match _notif_type:
		ggsCore.NotifType.NAME_INVALID:
			title = title_name_invalid
			dialog_text = text_name_invalid
		ggsCore.NotifType.NAME_EXISTS:
			title = title_name_exists
			dialog_text = text_name_exists


func _on_Global_notif_requested(type: ggsCore.NotifType) -> void:
	_notif_type = type
	_set_content()
	
	popup_centered(min_size)


func _on_visibility_changed() -> void:
	if not visible:
		GGS.Event.notif_closed.emit(_notif_type)
