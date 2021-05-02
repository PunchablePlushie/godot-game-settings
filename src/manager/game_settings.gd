extends Node

export(String) var save_path: String
export(String, FILE, "*.cfg") var default_file: String

var _config: ConfigFile = ConfigFile.new()

## Remember to add your custom setting node here
onready var Fullscreen: Node = $Fullscreen
onready var WindowSize: Node = $WindowSize
onready var AudioVolume: Node = $AudioVolume
onready var KbControls: Node = $KbControls
onready var GpControls: Node = $GpControls


func _ready() -> void:
	return
	var error = _config.load(save_path)
	if error != OK:
		error = _config.load(default_file)
		if error != OK:
			printerr("GGS: Could not find a default setting file.")
			return
	
	apply_all()


func get_setting(section: String, key: String):
	return _config.get_value(section, key, null)


func set_setting(section: String, key: String, value) -> void:
	_config.set_value(section, key, value)
	_config.save(save_path)


func apply_all() -> void:
	Fullscreen.set_value(get_setting(Fullscreen.section, Fullscreen.key))
	WindowSize.choose_and_apply(get_setting(WindowSize.section, WindowSize.key))
	
	# Audio
	for bus_name in AudioVolume.buses:
		var bus: Node = get_node("AudioVolume/%s"%[bus_name])
		bus.set_volume(bus.name, get_setting(bus.section, bus.key))
	
	# Keyboard Controls
	for action in KbControls.actions:
		var event: InputEventKey = InputEventKey.new()
		var node: Node = get_node("KbControls/%s"%[action])
		event.scancode = get_setting(node.section, node.key)
		node.change(event)
	
	# Gamepad Controls
	if GpControls.actions != []:
		for action in GpControls.actions:
			var event: InputEventJoypadButton = InputEventJoypadButton.new()
			var node: Node = get_node("GpControls/%s"%[action])
			event.button_index = get_setting(node.section, node.key)
			node.change(event)
