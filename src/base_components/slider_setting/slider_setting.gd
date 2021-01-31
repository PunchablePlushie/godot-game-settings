class_name SliderSetting
extends Control

export(String) var setting_name: String
export(String) var section_name: String = ""
export(String) var key_name: String = ""

onready var label: Label = $Label
onready var slider: HSlider = $HSlider

func _ready() -> void:
	slider.connect("value_changed", self, "_on_HSlider_value_changed")
	slider.value = SettingsManager.get_setting(section_name, key_name)
	label.text = setting_name
	
	# Tick count automatically changes by changing step, it ticks are enabled.
	if slider.ticks_on_borders:
# warning-ignore:narrowing_conversion
		slider.tick_count = (slider.max_value - slider.min_value) / slider.step


func update_value(new_value: float) -> void:
	SettingsManager.set_setting(section_name, key_name, new_value)


func _on_HSlider_value_changed(value: float) -> void:
	update_value(value)
