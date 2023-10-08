@tool
extends ggsUIComponent

@onready var slider: HSlider = $Slider


func _ready() -> void:
	compatible_types = [TYPE_INT, TYPE_FLOAT]
	if Engine.is_editor_hint():
		return
	
	super()
	slider.value_changed.connect(_on_Slider_value_changed)
	slider.mouse_entered.connect(_on_Slider_mouse_entered)
	slider.focus_entered.connect(_on_Slider_focus_entered)


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


### SFX

func _on_Slider_mouse_entered() -> void:
	GGS.play_sfx(GGS.SFX.MOUSE_OVER)
	
	if grab_focus_on_mouse_over:
		slider.grab_focus()


func _on_Slider_focus_entered() -> void:
	GGS.play_sfx(GGS.SFX.FOCUS)
