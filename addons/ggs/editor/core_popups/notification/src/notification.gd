@tool
extends AcceptDialog

enum Type {NAME_INVALID, NAME_EXISTS}

@export_group("Invalid Name", "invalid_")
@export var invalid_title: String
@export_multiline var invalid_text: String
@export_group("Name Exists", "exists_")
@export var exists_title: String
@export_multiline var exists_text: String


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	popup_centered(min_size)


func set_content(type: Type) -> void:
	match type:
		Type.NAME_INVALID:
			title = invalid_title
			dialog_text = invalid_text
		Type.NAME_EXISTS:
			title = exists_title
			dialog_text = exists_text


func _on_visibility_changed() -> void:
	if not visible:
		GGS.Event.notif_popup_closed.emit()
		queue_free()
