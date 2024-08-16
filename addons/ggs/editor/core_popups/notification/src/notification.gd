@tool
extends AcceptDialog

var content: ggsNotifContent


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	title = content.title
	dialog_text = content.text
	popup_centered(min_size)


func _on_visibility_changed() -> void:
	if not visible:
		GGS.Event.notif_popup_closed.emit()
		queue_free()
