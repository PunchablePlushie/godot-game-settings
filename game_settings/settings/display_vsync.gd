@tool
extends ggsSetting


func _init() -> void:
	super()
	name = "VSync Mode"
	
	value_type = TYPE_BOOL
	default = true


func apply(value: bool) -> void:
	var vsync_mode: DisplayServer.VSyncMode
	match value:
		true:
			vsync_mode = DisplayServer.VSYNC_ENABLED
		false:
			vsync_mode = DisplayServer.VSYNC_DISABLED
	
	DisplayServer.window_set_vsync_mode(vsync_mode)
