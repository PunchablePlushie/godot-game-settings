extends ggsUIComponent
signal option_selected(option_index: int)

@export_category("ArrowList")
@export var options: Array[String]

@onready var LeftBtn: Button = $HBox/LeftBtn
@onready var OptionLabel: Label = $HBox/OptionLabel
@onready var RightBtn: Button = $HBox/RightBtn


func _ready() -> void:
	super()
	option_selected.connect(_on_option_selected)
	LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	RightBtn.pressed.connect(_on_RightBtn_pressed)


func init_value() -> void:
	super()
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

func reset_setting() -> void:
	select(setting.default)
	apply_setting()
