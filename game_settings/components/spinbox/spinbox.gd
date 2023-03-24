extends ggsUIComponent

@onready var spin_box: SpinBox = $SpinBox
@onready var Field: LineEdit = spin_box.get_line_edit()


func _ready() -> void:
	super()
	spin_box.value_changed.connect(_on_SpinBox_value_changed)
	Field.context_menu_enabled = false


func init_value() -> void:
	super()
	spin_box.set_value_no_signal(setting_value)
	Field.text = str(setting_value)


func _on_SpinBox_value_changed(new_value: float) -> void:
	setting_value = new_value
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	spin_box.value = setting_value
	Field.text = str(setting_value)
