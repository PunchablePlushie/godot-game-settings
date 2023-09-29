@tool
extends ggsUIComponent

@export var use_ids: bool = false

@onready var Btn: OptionButton = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return
	
	super()
	Btn.item_selected.connect(_on_Btn_item_selected)


func init_value() -> void:
	super()
	
	if use_ids:
		Btn.select(Btn.get_item_index(setting_value))
	else:
		Btn.select(setting_value)


func _on_Btn_item_selected(item_index: int) -> void:
	if use_ids:
		setting_value = Btn.get_item_id(item_index)
	else:
		setting_value = item_index
	if apply_on_change:
		apply_setting()


### Setting


func reset_setting() -> void:
	super()
	Btn.select(setting_value)
