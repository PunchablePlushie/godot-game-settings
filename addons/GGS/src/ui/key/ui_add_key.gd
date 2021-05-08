tool
extends Button

var index: String
onready var KeyScene: PackedScene = preload("uiKey.tscn")


func _ready() -> void:
	hint_tooltip = "Add Key"


func _on_uiAddKey_pressed() -> void:
	var KeyInstance: HBoxContainer = KeyScene.instance()
	KeyInstance.index = index
	get_parent().add_child(KeyInstance)
	KeyInstance.ValueField.editable = false
	KeyInstance.TypeSelectionBtn.disabled = true
	raise()
