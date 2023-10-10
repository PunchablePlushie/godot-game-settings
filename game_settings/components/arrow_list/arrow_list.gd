@tool
extends ggsUIComponent
signal option_selected(option_index: int)

@export_category("ArrowList")
@export var options: PackedStringArray
@export var option_ids: PackedInt32Array

@onready var LeftBtn: Button = $HBox/LeftBtn
@onready var OptionLabel: Label = $HBox/OptionLabel
@onready var RightBtn: Button = $HBox/RightBtn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return
	
	super()
	option_selected.connect(_on_option_selected)
	LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	RightBtn.pressed.connect(_on_RightBtn_pressed)
	
	LeftBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(LeftBtn))
	RightBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(RightBtn))
	LeftBtn.focus_entered.connect(_on_AnyBtn_focus_entered)
	RightBtn.focus_entered.connect(_on_AnyBtn_focus_entered)


func init_value() -> void:
	super()
	
	if not option_ids.is_empty():
		var option_index: int = option_ids.find(setting_value)
		select(option_index, false)
	else:
		select(setting_value, false)


func _on_option_selected(_option_index: int) -> void:
	if apply_on_change:
		apply_setting()


### Interaction

func select(index: int, emit_selected: bool = true) -> void:
	index = index % options.size()
	
	OptionLabel.text = options[index]
	
	if not option_ids.is_empty():
		setting_value = option_ids[index]
	else:
		setting_value = index
	
	if emit_selected:
		option_selected.emit(index)


func _on_LeftBtn_pressed() -> void:
	if option_ids.is_empty():
		select(setting_value - 1)
	else:
		select(option_ids.find(setting_value) - 1)
	
	GGS.play_sfx(GGS.SFX.INTERACT)


func _on_RightBtn_pressed() -> void:
	if option_ids.is_empty():
		select(setting_value + 1)
	else:
		select(option_ids.find(setting_value) + 1)
	
	GGS.play_sfx(GGS.SFX.INTERACT)


### Setting

func reset_setting() -> void:
	select(setting.default)
	apply_setting()


### SFX

func _on_AnyBtn_mouse_entered(Btn: Button) -> void:
	GGS.play_sfx(GGS.SFX.MOUSE_OVER)
	
	if grab_focus_on_mouse_over:
		Btn.grab_focus()


func _on_AnyBtn_focus_entered() -> void:
	GGS.play_sfx(GGS.SFX.FOCUS)
