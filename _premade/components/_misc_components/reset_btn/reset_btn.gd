extends Button

@export var group: String
@export var grab_focus_on_mouse_over: bool


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)


func _on_pressed() -> void:
	get_tree().call_group(group, "reset_setting")
	GGS.play_sfx(GGS.SFX.INTERACT)


func _on_mouse_entered() -> void:
	GGS.play_sfx(GGS.SFX.MOUSE_OVER)
	
	if grab_focus_on_mouse_over:
		grab_focus()


func _on_focus_entered() -> void:
	GGS.play_sfx(GGS.SFX.FOCUS)
