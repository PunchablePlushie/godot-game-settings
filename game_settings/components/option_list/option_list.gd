extends OptionButton

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool

var value: int

@onready var section: String = setting.category
@onready var key: String = setting.name


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	
	value = ggsSaveFile.new().get_key(section, key)
	select(value)


func reset() -> void:
	value = setting.default
	select(value)
	apply()


func apply() -> void:
	setting.current = value
	setting.apply(value)


func _on_item_selected(item_index: int) -> void:
	value = item_index
	if apply_on_change:
		apply()
