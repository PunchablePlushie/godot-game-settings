@tool
extends ggsSetting


func apply(value: String) -> void:
	GM.player_name = value
	GM.property_changed.emit()
