@tool
extends RefCounted
class_name ggsInputHelper
## Provides input-related methods used throughout GGS.

enum InputType {
	INVALID,
	KEYBOARD,
	MOUSE,
	JOYPAD_BUTTON,
	JOYPAD_MOTION,
}

enum Axis {
	LS_LEFT, LS_RIGHT, LS_UP, LS_DOWN,
	RS_LEFT, RS_RIGHT, RS_UP, RS_DOWN,
	LT, RT
}

const AXIS_MAP: Dictionary = {
	JOY_AXIS_LEFT_X: [Axis.LS_RIGHT, Axis.LS_LEFT],
	JOY_AXIS_LEFT_Y: [Axis.LS_DOWN, Axis.LS_UP],
	JOY_AXIS_RIGHT_X: [Axis.RS_RIGHT, Axis.RS_LEFT],
	JOY_AXIS_RIGHT_Y: [Axis.RS_DOWN, Axis.RS_UP],
	JOY_AXIS_TRIGGER_LEFT: [Axis.LT],
	JOY_AXIS_TRIGGER_RIGHT: [Axis.RT],
}

const JOYPAD_DEVICE_ABBREVIATIONS: Dictionary = {
	"XInput Gamepad": "xbox",
	"Xbox Series Controller": "xbox",
	"Sony DualSense": "ps",
	"PS5 Controller": "ps",
	"PS4 Controller": "ps",
	"Switch": "switch",
}

const TEXT_MOUSE: Dictionary = {
	MOUSE_BUTTON_LEFT: "LMB",
	MOUSE_BUTTON_RIGHT: "RMB",
	MOUSE_BUTTON_MIDDLE: "MMB",
	MOUSE_BUTTON_WHEEL_UP: "MW Up",
	MOUSE_BUTTON_WHEEL_DOWN: "MW Down",
	MOUSE_BUTTON_WHEEL_LEFT: "MW Left",
	MOUSE_BUTTON_WHEEL_RIGHT: "MW Right",
	MOUSE_BUTTON_XBUTTON1: "MB1",
	MOUSE_BUTTON_XBUTTON2: "MB2",
}

const TEXT_XBOX: Dictionary = {
	JOY_BUTTON_A: "A",
	JOY_BUTTON_B: "B",
	JOY_BUTTON_X: "X",
	JOY_BUTTON_Y: "Y",
	JOY_BUTTON_BACK: "Back",
	JOY_BUTTON_GUIDE: "Home",
	JOY_BUTTON_START: "Start",
	JOY_BUTTON_LEFT_STICK: "LS",
	JOY_BUTTON_RIGHT_STICK: "RS",
	JOY_BUTTON_LEFT_SHOULDER: "LB",
	JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "Share",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}

const TEXT_XBOX_AXIS: Dictionary = {
	Axis.LS_LEFT: "LStick Left",
	Axis.LS_RIGHT: "LStick Right",
	Axis.LS_UP: "LStick Up",
	Axis.LS_DOWN: "LStick Down",
	Axis.RS_LEFT: "RStick Left",
	Axis.RS_RIGHT: "RStick Right",
	Axis.RS_UP: "RStick Up",
	Axis.RS_DOWN: "RStick Down",
	Axis.LT: "LT",
	Axis.RT: "RT",
}

const TEXT_PS: Dictionary = {
	JOY_BUTTON_A: "Cross",
	JOY_BUTTON_B: "Circle",
	JOY_BUTTON_X: "Square",
	JOY_BUTTON_Y: "Triangle",
	JOY_BUTTON_BACK: "Select",
	JOY_BUTTON_GUIDE: "PS",
	JOY_BUTTON_START: "Start",
	JOY_BUTTON_LEFT_STICK: "L3",
	JOY_BUTTON_RIGHT_STICK: "R3",
	JOY_BUTTON_LEFT_SHOULDER: "L1",
	JOY_BUTTON_RIGHT_SHOULDER: "R1",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "Microphone",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}

const TEXT_PS_AXIS: Dictionary = {
	Axis.LS_LEFT: "LStick Left",
	Axis.LS_RIGHT: "LStick Right",
	Axis.LS_UP: "LStick Up",
	Axis.LS_DOWN: "LStick Down",
	Axis.RS_LEFT: "RStick Left",
	Axis.RS_RIGHT: "RStick Right",
	Axis.RS_UP: "RStick Up",
	Axis.RS_DOWN: "RStick Down",
	Axis.LT: "L2",
	Axis.RT: "R2",
}

const TEXT_SWITCH: Dictionary = {
	JOY_BUTTON_A: "B",
	JOY_BUTTON_B: "A",
	JOY_BUTTON_X: "Y",
	JOY_BUTTON_Y: "X",
	JOY_BUTTON_BACK: "Minus",
	JOY_BUTTON_GUIDE: "Home",
	JOY_BUTTON_START: "Plus",
	JOY_BUTTON_LEFT_STICK: "LS",
	JOY_BUTTON_RIGHT_STICK: "RS",
	JOY_BUTTON_LEFT_SHOULDER: "L",
	JOY_BUTTON_RIGHT_SHOULDER: "R",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "Capture",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}

const TEXT_SWITCH_AXIS: Dictionary = {
	Axis.LS_LEFT: "LStick Left",
	Axis.LS_RIGHT: "LStick Right",
	Axis.LS_UP: "LStick Up",
	Axis.LS_DOWN: "LStick Down",
	Axis.RS_LEFT: "RStick Left",
	Axis.RS_RIGHT: "RStick Right",
	Axis.RS_UP: "RStick Up",
	Axis.RS_DOWN: "RStick Down",
	Axis.LT: "ZL",
	Axis.RT: "ZR",
}

const TEXT_OTHER: Dictionary = {
	JOY_BUTTON_A: "A",
	JOY_BUTTON_B: "B",
	JOY_BUTTON_X: "X",
	JOY_BUTTON_Y: "Y",
	JOY_BUTTON_BACK: "Back",
	JOY_BUTTON_GUIDE: "Guide",
	JOY_BUTTON_START: "Start",
	JOY_BUTTON_LEFT_STICK: "LS",
	JOY_BUTTON_RIGHT_STICK: "RS",
	JOY_BUTTON_LEFT_SHOULDER: "L",
	JOY_BUTTON_RIGHT_SHOULDER: "R",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "MISC1",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}

const TEXT_OTHER_AXIS: Dictionary = {
	Axis.LS_LEFT: "LStick Left",
	Axis.LS_RIGHT: "LStick Right",
	Axis.LS_UP: "LStick Up",
	Axis.LS_DOWN: "LStick Down",
	Axis.RS_LEFT: "RStick Left",
	Axis.RS_RIGHT: "RStick Right",
	Axis.RS_UP: "RStick Up",
	Axis.RS_DOWN: "RStick Down",
	Axis.LT: "LT",
	Axis.RT: "RT",
}

const MODIFIERS_MASK: int = KEY_MASK_SHIFT | KEY_MASK_CTRL | KEY_MASK_ALT


## Retrieves the user-defined input map from the project settings.
## Unlike [InputMap], it works in the editor as well.
static func get_input_map() -> Dictionary:
	var input_map: Dictionary

	var project_file: ConfigFile = ConfigFile.new()
	project_file.load("res://project.godot")

	var actions: PackedStringArray = project_file.get_section_keys("input")
	for action: String in actions:
		var action_properties: Dictionary = project_file.get_value("input", action)
		var action_events: Array = action_properties["events"]

		input_map[action] = action_events

	return input_map


## Serializes the given event by saving its important properties in an array.
static func serialize_event(event: InputEvent) -> Array:
	var type: int = -1
	var id: int = -1
	var aux: int = -1

	if event is InputEventKey:
		type = InputType.KEYBOARD
		id = event.physical_keycode | event.get_modifiers_mask()

	if event is InputEventMouseButton:
		type = InputType.MOUSE
		id = event.button_index | event.get_modifiers_mask()

	if event is InputEventJoypadButton:
		type = InputType.JOYPAD_BUTTON
		id = event.button_index

	if event is InputEventJoypadMotion:
		type = InputType.JOYPAD_MOTION
		id = event.axis
		aux = 0 if event.axis_value > 0 else 1

	return [type, id, aux]


## Recreates the [InputEvent] created via [method serialize_event].
static func deserialize_event(data: Array) -> InputEvent:
	var type: int = data[0]
	var id: int = data[1]
	var aux: int = data[2]

	var event: InputEvent
	if type == InputType.KEYBOARD:
		event = InputEventKey.new()
		event.physical_keycode = id & ~MODIFIERS_MASK
		event.shift_pressed = bool(id & KEY_MASK_SHIFT)
		event.ctrl_pressed = bool(id & KEY_MASK_CTRL)
		event.alt_pressed = bool(id & KEY_MASK_ALT)

	if type == InputType.MOUSE:
		event = InputEventMouseButton.new()
		event.button_index = id & ~MODIFIERS_MASK
		event.shift_pressed = bool(id & KEY_MASK_SHIFT)
		event.ctrl_pressed = bool(id & KEY_MASK_CTRL)
		event.alt_pressed = bool(id & KEY_MASK_ALT)

	if type == InputType.JOYPAD_BUTTON:
		event = InputEventJoypadButton.new()
		event.button_index = id

	if type == InputType.JOYPAD_MOTION:
		event = InputEventJoypadMotion.new()
		event.axis = id
		event.axis_value = -1 if aux == 1 else 1

	return event


## Returns a string representation of the event. Unlike
## [method InputEvent.as_text], it returns a shorter string that also
## changes based on gamepad type. Uses [code]TEXT_*[/code] and
## [code]TEXT_*_AXIS[/code] constants.
func event_get_text(event: InputEvent) -> String:
	var text: String = "INVALID EVENT"

	if event is InputEventKey:
		var keycode_with_modif: int = event.get_physical_keycode_with_modifiers()
		text = OS.get_keycode_string(keycode_with_modif)

	if event is InputEventMouse:
		var modif_text: String = _event_get_modifiers_text(event)
		var btn_text: String = TEXT_MOUSE[event.button_index]
		text = btn_text if modif_text.is_empty() else "%s+%s"%[modif_text, btn_text]

	if event is InputEventJoypadButton:
		var device: String = _joypad_get_device_abbreviated(event)
		var property: String = "TEXT_%s"%[device.to_upper()]
		prints(device, property)
		text = get(property)[event.button_index]

	if event is InputEventJoypadMotion:
		var device: String = _joypad_get_device_abbreviated(event)
		var property: String = "TEXT_%s_AXIS"%[device.to_upper()]
		var axis: Axis = _joypad_get_axis_mapped(event)
		text = get(property)[axis]

	return text


## Returns a [Texture2D] representation of the event. Uses a [ggsGlyphDB]
## to retreive appropriate textures.
func event_get_glyph(event: InputEvent, db: ggsGlyphDB) -> Texture2D:
	var glyph: Texture2D = null

	if event is InputEventMouseButton:
		var property: String = "mouse_%s"%db.MOUSE[event.button_index]
		glyph = db.get(property)

	if event is InputEventJoypadButton:
		var device: String = _joypad_get_device_abbreviated(event)
		var btn_text: String = db.JOYPAD_BUTTON[event.button_index]
		var property: String = "%s_%s"%[device, btn_text]
		glyph = db.get(property)

	if event is InputEventJoypadMotion:
		var device: String = _joypad_get_device_abbreviated(event)
		var axis: Axis = _joypad_get_axis_mapped(event)
		var axis_text: String = db.JOYPAD_AXIS[axis]
		var property: String = "%s_%s"%[device, axis_text]
		glyph = db.get(property)

	return glyph


func _event_get_modifiers_text(event: InputEventWithModifiers) -> String:
	var modifiers: PackedStringArray
	if event.shift_pressed:
		modifiers.append("Shift")

	if event.ctrl_pressed:
		modifiers.append("Ctrl")

	if event.alt_pressed:
		modifiers.append("Alt")

	var modifiers_string: String = "+".join(modifiers)
	return modifiers_string


func _joypad_get_device_abbreviated(event: InputEvent) -> String:
	var device_name: String = Input.get_joy_name(event.device)

	if JOYPAD_DEVICE_ABBREVIATIONS.has(device_name):
		return JOYPAD_DEVICE_ABBREVIATIONS[device_name]
	else:
		return GGS.default_glyph.strip_edges()


func _joypad_get_axis_mapped(event: InputEvent) -> Axis:
	var idx: int = 1 if event.axis_value < 0 else 0
	return AXIS_MAP[event.axis][idx]
