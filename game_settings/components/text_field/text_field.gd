extends ggsUIComponent

@onready var TextField: LineEdit = $TextField


func _ready() -> void:
	super()
	TextField.text_submitted.connect(_on_TextField_text_submitted)


func init_value() -> void:
	super()
	TextField.text = setting_value


func _on_TextField_text_submitted(submitted_text: String) -> void:
	setting_value = submitted_text
	if apply_on_change:
		apply_setting()


### Setting

func reset_setting() -> void:
	super()
	TextField.text = setting_value
