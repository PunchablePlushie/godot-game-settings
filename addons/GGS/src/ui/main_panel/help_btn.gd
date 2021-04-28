tool
extends Button


func _ready():
	hint_tooltip = "Open Github Wiki / Documentation"


func _on_Help_pressed():
	OS.shell_open("https://github.com/PunchablePlushie/godot_ggs/wiki")
