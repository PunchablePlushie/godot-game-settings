@tool
extends ggsSetting


func _init() -> void:
	super()
	name = "Shuriken Count"
	
	value_type = TYPE_INT
	default = 50
	value_hint = PROPERTY_HINT_RANGE
	value_hint_string = "0, 100"


func apply(value: int) -> void:
	print("Shuriken count changed: %d"%value)
