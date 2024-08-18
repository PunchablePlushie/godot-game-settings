@tool
extends AcceptDialog


func _init() -> void:
	visible = false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	GGS.Event.notif_requested.connect(_on_Global_notif_requested)


func _on_Global_notif_requested(ttl: String, txt: String) -> void:
	title = ttl
	dialog_text = txt
	popup_centered(min_size)


func _on_visibility_changed() -> void:
	if not visible:
		GGS.Event.notif_closed.emit()
