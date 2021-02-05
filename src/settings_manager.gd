extends Node

export(String) var save_path: String = "res://settings.cfg"
export(String, FILE, "*.cfg") var default_file: String
export(bool) var use_basic_window_scaling: bool = true
export(bool) var use_slider_for_audio: bool = true
export(bool) var use_gp_setting: bool = false
export(bool) var use_audio_system: bool = false
export(AudioStream) var select_sfx: AudioStream
export(AudioStream) var focus_sfx: AudioStream
export(AudioStream) var error_sfx: AudioStream


var _config: ConfigFile = ConfigFile.new()
var _sfxs: Array = []
var _window_base_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

onready var audio_player: AudioStreamPlayer = $AudioPlayer


func _ready() -> void:
	_sfxs = [select_sfx, focus_sfx, error_sfx]
	
	var error = _config.load(save_path)
	if error != OK:
		_config.load(default_file)
	
	apply_settings()


func get_setting(section: String, key: String):
	return _config.get_value(section, key, null)


func set_setting(section: String, key: String, value) -> void:
	_config.set_value(section, key, value)
	_config.save(save_path)


func play_sfx(type: int) -> void:
	if use_audio_system == false:
		return
	audio_player.stream = _sfxs[type]
	audio_player.play()


func apply_settings() -> void:
	logic_fullscreen(get_setting("display", "fullscreen"))
	_apply_window_scale_settings()
	_apply_volume_settings()
	_apply_control_settings()


# Logic methods
func logic_fullscreen(fullscreen: bool) -> void:
	OS.window_fullscreen = fullscreen


func logic_window_scale(scale: int) -> void:
	var smallest_scale: int = 2
	OS.window_size = _window_base_size * (scale + smallest_scale)
	_center_window()


func logic_window_resolution(resolution_index: int) -> void:
	var resolutions: Dictionary = {
		"0": Vector2(640, 360),
		"1": Vector2(1280, 720),
		"2": Vector2(1980, 1080),
	}
	
	OS.window_size = resolutions[str(resolution_index)]
	_center_window()


func logic_audio_volume(bus_name: String, volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))


func logic_audio_volume_al(bus_name: String, new_value: int, scale_range: Vector2) -> void:
	# Remap the current value from scale_range to [0,1] range.
	var volume: float = range_lerp(new_value, 
			scale_range.x, scale_range.y,
			0, 1)
	logic_audio_volume(bus_name, volume)


func logic_change_kb_control(action_name: String, new_key: InputEventKey) -> void:
	var action_list: Array = InputMap.get_action_list(action_name)
	InputMap.action_erase_event(action_name, action_list[0])
	InputMap.action_add_event(action_name, new_key)


func logic_change_gp_control(action_name: String, new_button: InputEventJoypadButton) -> void:
	var action_list: Array = InputMap.get_action_list(action_name)
	InputMap.action_erase_event(action_name, action_list[1])
	InputMap.action_add_event(action_name, new_button)


# Local utility functions
func _apply_window_scale_settings() -> void:
	if use_basic_window_scaling:
		logic_window_scale(get_setting("display", "window_scale"))
	else:
		logic_window_resolution(get_setting("display", "window_resolution"))


func _apply_volume_settings() -> void:
	# Update audio_buses with your own buses.
	var audio_buses: Array = ["Master"]
	for bus in audio_buses:
		if use_slider_for_audio:
			logic_audio_volume(
				bus,
				get_setting("audio", "%s_volume"%[bus.to_lower()])
			)
		else:
			logic_audio_volume_al(
				bus,
				get_setting("audio", "%s_volume"%[bus.to_lower()]),
				Vector2(0, 10)
			)


func _apply_control_settings() -> void:
	# Update actions with your own actions.
	var actions: Array = ["move_right", "move_left"]
	for action in actions:
		if use_gp_setting == false:
			var event: InputEventKey = InputEventKey.new()
			event.scancode = get_setting("controls", action)
			logic_change_kb_control(action, event)
		else:
			var kb_event: InputEventKey = InputEventKey.new()
			kb_event.scancode = get_setting("controls", "%s_kb"%[action])
			logic_change_kb_control(action, kb_event)
			
			var gp_event: InputEventJoypadButton = InputEventJoypadButton.new()
			gp_event.button_index = get_setting("controls", "%s_gp"%[action])
			logic_change_gp_control(action, gp_event)


func _center_window() -> void:
	var display_center: Vector2 = OS.get_screen_size() / 2
	OS.window_position = display_center - (OS.window_size / 2)
