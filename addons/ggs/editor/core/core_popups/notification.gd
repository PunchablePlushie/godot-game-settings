@tool
extends AcceptDialog

@export_group("Name Invalid", "invalid_")
@export var invalid_title: String
@export_multiline var invalid_message: String

@export_group("Name Exists", "exists_")
@export var exists_title: String
@export_multiline var exists_message: String


func _ready() -> void:
	close_requested.connect(_on_closed)
	confirmed.connect(_on_closed)
	GGS.Event.PopupNotif.name_invalid.connect(_on_name_invalid)
	GGS.Event.PopupNotif.name_exists.connect(_on_name_exists)


func _notify_user(ttl: String, msg: String) -> void:
	title = ttl
	dialog_text = msg
	popup_centered(min_size)


func _on_closed() -> void:
	GGS.Event.PopupNotif.notif_closed.emit()


# Notifications #
func _on_name_invalid() -> void:
	_notify_user(invalid_title, invalid_message)


func _on_name_exists() -> void:
	_notify_user(exists_title, exists_message)
