@icon("res://addons/ggs/plugin/assets/apply_btn.svg")
extends Button

## Node group associated with the button. When pressed, the button calls
## [method ggsComponent.apply_setting] on all nodes in this node group.
@export var group: String

## If true, the main control(s) of the component will grab focus when
## mouse enters it.
@export var grab_focus_on_mouse_over: bool


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)


func _on_pressed() -> void:
	get_tree().call_group(group, "apply_setting")
	GGS.Audio.Interact.play()


func _on_mouse_entered() -> void:
	GGS.Audio.MouseEntered.play()

	if grab_focus_on_mouse_over:
		grab_focus()


func _on_focus_entered() -> void:
	GGS.Audio.FocusEntered.play()
