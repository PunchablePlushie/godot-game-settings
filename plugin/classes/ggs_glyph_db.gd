@tool
extends Resource
class_name ggsGlyphDB
## Stores varius textures used to display an input as a glyph. View
## [method ggsInputHelper.event_get_glyph] for more info.

const MOUSE: Dictionary = {
	MOUSE_BUTTON_LEFT: "left",
	MOUSE_BUTTON_RIGHT: "right",
	MOUSE_BUTTON_MIDDLE: "middle",
	MOUSE_BUTTON_WHEEL_UP: "wheel_up",
	MOUSE_BUTTON_WHEEL_DOWN: "wheel_down",
	MOUSE_BUTTON_WHEEL_LEFT: "wheel_left",
	MOUSE_BUTTON_WHEEL_RIGHT: "wheel_right",
	MOUSE_BUTTON_XBUTTON1: "extra_1",
	MOUSE_BUTTON_XBUTTON2: "extra_2",
}

const JOYPAD_BUTTON: Dictionary = {
	JOY_BUTTON_A: "bottom",
	JOY_BUTTON_B: "right",
	JOY_BUTTON_X: "left",
	JOY_BUTTON_Y: "top",
	JOY_BUTTON_BACK: "back",
	JOY_BUTTON_GUIDE: "guide",
	JOY_BUTTON_START: "start",
	JOY_BUTTON_LEFT_STICK: "left_stick",
	JOY_BUTTON_RIGHT_STICK: "right_stick",
	JOY_BUTTON_LEFT_SHOULDER: "left_shoulder",
	JOY_BUTTON_RIGHT_SHOULDER: "right_shoulder",
	JOY_BUTTON_DPAD_UP: "dpad_up",
	JOY_BUTTON_DPAD_DOWN: "dpad_down",
	JOY_BUTTON_DPAD_LEFT: "dpad_left",
	JOY_BUTTON_DPAD_RIGHT: "dpad_right",
	JOY_BUTTON_MISC1: "misc",
	JOY_BUTTON_PADDLE1: "pad1",
	JOY_BUTTON_PADDLE2: "pad2",
	JOY_BUTTON_PADDLE3: "pad3",
	JOY_BUTTON_PADDLE4: "pad4",
	JOY_BUTTON_TOUCHPAD: "touch"
}

const JOYPAD_AXIS: Dictionary = {
	ggsInputHelper.Axis.LS_LEFT: "lstick_left",
	ggsInputHelper.Axis.LS_RIGHT: "lstick_right",
	ggsInputHelper.Axis.LS_UP: "lstick_up",
	ggsInputHelper.Axis.LS_DOWN: "lstick_down",
	ggsInputHelper.Axis.RS_LEFT: "rstick_left",
	ggsInputHelper.Axis.RS_RIGHT: "rstick_right",
	ggsInputHelper.Axis.RS_UP: "rstick_up",
	ggsInputHelper.Axis.RS_DOWN: "rstick_down",
	ggsInputHelper.Axis.LT: "left_trigger",
	ggsInputHelper.Axis.RT: "right_trigger",
}

@export_group("Mouse", "mouse_")
@export var mouse_left: Texture2D
@export var mouse_right: Texture2D
@export var mouse_middle: Texture2D
@export var mouse_wheel_up: Texture2D
@export var mouse_wheel_down: Texture2D
@export var mouse_wheel_left: Texture2D
@export var mouse_wheel_right: Texture2D
@export var mouse_extra_1: Texture2D
@export var mouse_extra_2: Texture2D

@export_group("XBox", "xbox_")
@export_subgroup("XBox Buttons", "xbox_")
@export var xbox_bottom: Texture2D
@export var xbox_right: Texture2D
@export var xbox_left: Texture2D
@export var xbox_top: Texture2D
@export var xbox_back: Texture2D
@export var xbox_guide: Texture2D
@export var xbox_start: Texture2D
@export var xbox_left_stick: Texture2D
@export var xbox_right_stick: Texture2D
@export var xbox_left_shoulder: Texture2D
@export var xbox_right_shoulder: Texture2D
@export var xbox_dpad_up: Texture2D
@export var xbox_dpad_down: Texture2D
@export var xbox_dpad_left: Texture2D
@export var xbox_dpad_right: Texture2D
@export var xbox_misc: Texture2D
@export var xbox_pad1: Texture2D
@export var xbox_pad2: Texture2D
@export var xbox_pad3: Texture2D
@export var xbox_pad4: Texture2D
@export var xbox_touch: Texture2D
@export_subgroup("XBox Motions", "xbox_")
@export var xbox_lstick_left: Texture2D
@export var xbox_lstick_right: Texture2D
@export var xbox_lstick_up: Texture2D
@export var xbox_lstick_down: Texture2D
@export var xbox_rstick_left: Texture2D
@export var xbox_rstick_right: Texture2D
@export var xbox_rstick_up: Texture2D
@export var xbox_rstick_down: Texture2D
@export var xbox_left_trigger: Texture2D
@export var xbox_right_trigger: Texture2D

@export_group("Playstation", "ps_")
@export_subgroup("PS Buttons", "ps_")
@export var ps_bottom: Texture2D
@export var ps_right: Texture2D
@export var ps_left: Texture2D
@export var ps_top: Texture2D
@export var ps_back: Texture2D
@export var ps_guide: Texture2D
@export var ps_start: Texture2D
@export var ps_left_stick: Texture2D
@export var ps_right_stick: Texture2D
@export var ps_left_shoulder: Texture2D
@export var ps_right_shoulder: Texture2D
@export var ps_dpad_up: Texture2D
@export var ps_dpad_down: Texture2D
@export var ps_dpad_left: Texture2D
@export var ps_dpad_right: Texture2D
@export var ps_misc: Texture2D
@export var ps_pad1: Texture2D
@export var ps_pad2: Texture2D
@export var ps_pad3: Texture2D
@export var ps_pad4: Texture2D
@export var ps_touch: Texture2D
@export_subgroup("PS Motions", "ps_")
@export var ps_lstick_left: Texture2D
@export var ps_lstick_right: Texture2D
@export var ps_lstick_up: Texture2D
@export var ps_lstick_down: Texture2D
@export var ps_rstick_left: Texture2D
@export var ps_rstick_right: Texture2D
@export var ps_rstick_up: Texture2D
@export var ps_rstick_down: Texture2D
@export var ps_left_trigger: Texture2D
@export var ps_right_trigger: Texture2D


@export_group("Switch", "switch_")
@export_subgroup("Switch Buttons", "switch_")
@export var switch_bottom: Texture2D
@export var switch_right: Texture2D
@export var switch_left: Texture2D
@export var switch_top: Texture2D
@export var switch_back: Texture2D
@export var switch_guide: Texture2D
@export var switch_start: Texture2D
@export var switch_left_stick: Texture2D
@export var switch_right_stick: Texture2D
@export var switch_left_shoulder: Texture2D
@export var switch_right_shoulder: Texture2D
@export var switch_dpad_up: Texture2D
@export var switch_dpad_down: Texture2D
@export var switch_dpad_left: Texture2D
@export var switch_dpad_right: Texture2D
@export var switch_misc: Texture2D
@export var switch_pad1: Texture2D
@export var switch_pad2: Texture2D
@export var switch_pad3: Texture2D
@export var switch_pad4: Texture2D
@export var switch_touch: Texture2D
@export_subgroup("Switch Motions", "switch_")
@export var switch_lstick_left: Texture2D
@export var switch_lstick_right: Texture2D
@export var switch_lstick_up: Texture2D
@export var switch_lstick_down: Texture2D
@export var switch_rstick_left: Texture2D
@export var switch_rstick_right: Texture2D
@export var switch_rstick_up: Texture2D
@export var switch_rstick_down: Texture2D
@export var switch_left_trigger: Texture2D
@export var switch_right_trigger: Texture2D

@export_group("Other", "other_")
@export_subgroup("Other Buttons", "other_")
@export var other_bottom: Texture2D
@export var other_right: Texture2D
@export var other_left: Texture2D
@export var other_top: Texture2D
@export var other_back: Texture2D
@export var other_guide: Texture2D
@export var other_start: Texture2D
@export var other_left_stick: Texture2D
@export var other_right_stick: Texture2D
@export var other_left_shoulder: Texture2D
@export var other_right_shoulder: Texture2D
@export var other_dpad_up: Texture2D
@export var other_dpad_down: Texture2D
@export var other_dpad_left: Texture2D
@export var other_dpad_right: Texture2D
@export var other_misc: Texture2D
@export var other_pad1: Texture2D
@export var other_pad2: Texture2D
@export var other_pad3: Texture2D
@export var other_pad4: Texture2D
@export var other_touch: Texture2D
@export_subgroup("Other Motions", "other_")
@export var other_lstick_left: Texture2D
@export var other_lstick_right: Texture2D
@export var other_lstick_up: Texture2D
@export var other_lstick_down: Texture2D
@export var other_rstick_left: Texture2D
@export var other_rstick_right: Texture2D
@export var other_rstick_up: Texture2D
@export var other_rstick_down: Texture2D
@export var other_left_trigger: Texture2D
@export var other_right_trigger: Texture2D
