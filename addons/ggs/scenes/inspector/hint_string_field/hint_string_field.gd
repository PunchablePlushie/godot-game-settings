@tool
extends EditorProperty

const PROPERTY: String = "value_hint_string"

@export_group("Nodes")
@export var _Field: LineEdit

@onready var _obj: ggsSetting = get_edited_object()


func _ready() -> void:
	_Field.text_submitted.connect(_on_Field_text_submitted)
	
	_Field.text = _obj.get(PROPERTY)


func _update_property() -> void:
	_Field.text = _obj.get(PROPERTY)


func _on_Field_text_submitted(submitted_text: String) -> void:
	_obj.set(PROPERTY, submitted_text)
	emit_changed(PROPERTY, submitted_text)
	_obj.notify_property_list_changed()
