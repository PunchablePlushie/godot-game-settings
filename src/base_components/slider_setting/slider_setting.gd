class_name SliderSetting
extends BaseComponent

onready var setting: Node = GameSettings.get_node(setting_node)
onready var label: Label = $Label
onready var slider: HSlider = $HSlider


func _ready() -> void:
	if starts_with_focus:
		slider.grab_focus()
	
	slider.value = GameSettings.get_setting(setting.section, setting.key)
	slider.connect("value_changed", self, "_on_HSlider_value_changed")


func update_value(new_value: float) -> void:
	GameSettings.set_setting(setting.section, setting.key, new_value)


func _on_HSlider_value_changed(value: float) -> void:
	update_value(value)
