@tool
extends Control

const ICON: Texture2D = preload("res://addons/ggs/assets/components/_default.svg")

@onready var List: ItemList = $ComponentList


func _ready() -> void:
	for i in range(13):
		var disabled: bool = bool(randi() % 2)
		List.add_item("Some Component", ICON)
		List.set_item_disabled(i, disabled)
