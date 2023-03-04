extends HBoxContainer
signal option_selected(option_index: int)

@export_category("GGS UI Component")
@export var setting: ggsSetting
@export var apply_on_change: bool
@export var options: Array[String]

var setting_value: int

@onready var save_section: String = setting.category
@onready var save_key: String = setting.name

@onready var LeftBtn: Button = $LeftBtn
@onready var OptionLabel: Label = $OptionLabel
@onready var RightBtn: Button = $RightBtn


func _ready() -> void:
	option_selected.connect(_on_option_selected)
	LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	RightBtn.pressed.connect(_on_RightBtn_pressed)
	
	_init_value()


func _init_value() -> void:
	setting_value = ggsSaveFile.new().get_key(save_section, save_key)
	select(setting_value, false)


func _on_option_selected(_option_index: int) -> void:
	if apply_on_change:
		apply_setting()


### Interaction

func select(index: int, emit_selected: bool = true) -> void:
	index = index % options.size()
	
	OptionLabel.text = options[index]
	setting_value = index
	
	if emit_selected:
		option_selected.emit(index)


func _on_LeftBtn_pressed() -> void:
	select(setting_value - 1)


func _on_RightBtn_pressed() -> void:
	select(setting_value + 1)


### Setting

func apply_setting() -> void:
	setting.current = setting_value
	setting.apply(setting_value)


func reset_setting() -> void:
	select(setting.default)
	apply_setting()
