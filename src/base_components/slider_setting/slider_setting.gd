tool
class_name SliderSetting
extends BaseComponent

onready var label: Label = $Label
onready var slider: HSlider = $HSlider


func _ready() -> void:
	if starts_with_focus:
		slider.grab_focus()
	
	slider.value = SettingsManager.get_setting(section_name, key_name)
	slider.connect("value_changed", self, "_on_HSlider_value_changed")


func update_value(new_value: float) -> void:
	SettingsManager.set_setting(section_name, key_name, new_value)


func _on_HSlider_value_changed(value: float) -> void:
	update_value(value)
