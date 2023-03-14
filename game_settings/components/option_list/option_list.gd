extends ggsUIComponent

@onready var Btn: OptionButton = $Btn


func _ready() -> void:
	super()
	Btn.item_selected.connect(_on_Btn_item_selected)


func init_value() -> void:
	super()
	Btn.select(setting_value)


func _on_Btn_item_selected(item_index: int) -> void:
	setting_value = item_index
	if apply_on_change:
		apply_setting()


### Setting


func reset_setting() -> void:
	super()
	Btn.select(setting_value)
