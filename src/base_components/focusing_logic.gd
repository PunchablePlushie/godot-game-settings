extends Control


func _ready() -> void:
	# Prevents the playback of focus sfx at the start of the scene
	yield(get_tree().create_timer(0.5), "timeout")
	
	connect("focus_entered", self, "_on_focus_entered")
	connect("mouse_entered", self, "_on_mouse_entered")


func _on_focus_entered() -> void:
	SettingsManager.play_sfx(1)


func _on_mouse_entered() -> void:
	grab_focus()
