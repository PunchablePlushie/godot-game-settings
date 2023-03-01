extends HBoxContainer
signal option_selected(option_index: int)

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool
@export var options: Array[String]

var value: int

@onready var section: String = setting.category
@onready var key: String = setting.name
@onready var LeftBtn: Button = $LeftBtn
@onready var OptionLabel: Label = $OptionLabel
@onready var RightBtn: Button = $RightBtn


func _ready() -> void:
	option_selected.connect(_on_option_selected)
	LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	RightBtn.pressed.connect(_on_RightBtn_pressed)
	
	value = ggsSaveFile.new().get_key(section, key)
	select(value, false)


func select(index: int, emit_selected: bool = true) -> void:
	index = index % options.size()
	
	OptionLabel.text = options[index]
	value = index
	
	if emit_selected:
		option_selected.emit(index)


func _on_option_selected(_option_index: int) -> void:
	if apply_on_change:
		apply()


func _on_LeftBtn_pressed() -> void:
	select(value - 1)


func _on_RightBtn_pressed() -> void:
	select(value + 1)


### Setting

func apply() -> void:
	setting.current = value
	setting.apply(value)


func reset() -> void:
	select(setting.default)
	apply()
