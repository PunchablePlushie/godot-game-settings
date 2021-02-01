tool
class_name SliderSetting
extends BaseComponent


onready var label: Label = $Label
onready var slider: HSlider = $HSlider

func _ready() -> void:
	slider.value = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name


func update_value(new_value: float) -> void:
	SettingsManager.set_setting(section_name, key_name, new_value)


func _on_HSlider_value_changed(value: float) -> void:
	update_value(value)
