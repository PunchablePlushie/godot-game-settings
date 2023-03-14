extends ggsUIComponent

@onready var slider: HSlider = $Slider


func _ready() -> void:
	super()
	slider.value_changed.connect(_on_Slider_value_changed)


func init_value() -> void:
	super()
	slider.set_value_no_signal(setting_value)


func _on_Slider_value_changed(new_value: float) -> void:
	setting_value = new_value
	
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	slider.value = setting_value
