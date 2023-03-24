@tool
extends ggsSetting

enum Difficulty {Easy, Medium, Hard}


func _init() -> void:
	super()
	name = "Difficulty"
	
	value_type = TYPE_INT
	default = Difficulty.Medium
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = "Easy,Medium,Hard"


func apply(value: Difficulty) -> void:
	print("Game difficulty changed: %d"%value)
