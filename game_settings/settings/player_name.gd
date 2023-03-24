@tool
extends ggsSetting


func _init() -> void:
	super()
	name = "Player Name"
	
	value_type = TYPE_STRING
	default = "Joe Musashi"


func apply(value: String) -> void:
	print("Player name changed: %s"%value)
