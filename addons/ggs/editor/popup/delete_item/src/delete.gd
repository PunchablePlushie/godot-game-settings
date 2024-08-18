@tool
extends ConfirmationDialog

enum Type {CATEGORY, GROUP, SETTING}

signal delete_confirmed(item_name: String)

@export_group("Texts", "text_")
@export_multiline var text_category: String
@export_multiline var text_group: String
@export_multiline var text_setting: String

var item_name: String


func _ready() -> void:
	confirmed.connect(_on_confirmed)
	visibility_changed.connect(_on_visibility_changed)
	
	popup_centered(min_size)


func set_content(type: Type) -> void:
	match type:
		Type.CATEGORY:
			dialog_text = text_category.format([item_name])
		Type.GROUP:
			dialog_text = text_group.format([item_name])
		Type.SETTING:
			dialog_text = text_setting.format([item_name])


func _on_confirmed() -> void:
	delete_confirmed.emit(item_name)


func _on_visibility_changed() -> void:
	if not visible:
		queue_free()
