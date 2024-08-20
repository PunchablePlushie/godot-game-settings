@tool
extends Resource
class_name ggsIconDB

var property_map: Dictionary = {
	"mouse_button": [
		"lmb", "rmb", "mmb", "mw_up", "mw_down", "mw_left", "mw_right", "mb1", "mb2"
	],
	
	"gp_button": [
		"bot", "right", "left", "top",
		"back", "guide", "start",
		"left_stick", "right_stick",
		"left_shoulder", "right_shoulder",
		"dup", "ddown", "dleft", "dright",
		"misc", "pad1", "pad2", "pad3", "pad4",
		"touch"
	],
	
	"gp_motion": [
		{"-": "ls_left", "+": "ls_right"},
		{"-": "ls_down", "+": "ls_up"},
		{"-": "rs_left", "+": "rs_right"},
		{"-": "rs_down", "+": "rs_up"},
		{"+": "left_trigger"},
		{"+": "right_trigger"},
	],
}


@export_category("Icon Database")
@export_group("Mouse", "mouse_")
@export var mouse_lmb: Texture2D
@export var mouse_rmb: Texture2D
@export var mouse_mmb: Texture2D
@export var mouse_mw_up: Texture2D
@export var mouse_mw_down: Texture2D
@export var mouse_mw_left: Texture2D
@export var mouse_mw_right: Texture2D
@export var mouse_mb1: Texture2D
@export var mouse_mb2: Texture2D

@export_group("XBox", "xbox_")
@export_subgroup("XBox Motions", "xbox_")
@export var xbox_ls_left: Texture2D
@export var xbox_ls_right: Texture2D
@export var xbox_ls_up: Texture2D
@export var xbox_ls_down: Texture2D
@export var xbox_rs_left: Texture2D
@export var xbox_rs_right: Texture2D
@export var xbox_rs_up: Texture2D
@export var xbox_rs_down: Texture2D
@export var xbox_left_trigger: Texture2D
@export var xbox_right_trigger: Texture2D
@export_subgroup("XBox Buttons", "xbox_")
@export var xbox_bot: Texture2D
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
@export var xbox_dup: Texture2D
@export var xbox_ddown: Texture2D
@export var xbox_dleft: Texture2D
@export var xbox_dright: Texture2D
@export var xbox_misc: Texture2D
@export var xbox_pad1: Texture2D
@export var xbox_pad2: Texture2D
@export var xbox_pad3: Texture2D
@export var xbox_pad4: Texture2D
@export var xbox_touch: Texture2D

@export_group("Playstation", "ps_")
@export_subgroup("PS Motions", "ps_")
@export var ps_ls_left: Texture2D
@export var ps_ls_right: Texture2D
@export var ps_ls_up: Texture2D
@export var ps_ls_down: Texture2D
@export var ps_rs_left: Texture2D
@export var ps_rs_right: Texture2D
@export var ps_rs_up: Texture2D
@export var ps_rs_down: Texture2D
@export var ps_left_trigger: Texture2D
@export var ps_right_trigger: Texture2D
@export_subgroup("PS Buttons", "ps_")
@export var ps_bot: Texture2D
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
@export var ps_dup: Texture2D
@export var ps_ddown: Texture2D
@export var ps_dleft: Texture2D
@export var ps_dright: Texture2D
@export var ps_misc: Texture2D
@export var ps_pad1: Texture2D
@export var ps_pad2: Texture2D
@export var ps_pad3: Texture2D
@export var ps_pad4: Texture2D
@export var ps_touch: Texture2D

@export_group("Switch", "switch_")
@export_subgroup("Switch Motions", "switch_")
@export var switch_ls_left: Texture2D
@export var switch_ls_right: Texture2D
@export var switch_ls_up: Texture2D
@export var switch_ls_down: Texture2D
@export var switch_rs_left: Texture2D
@export var switch_rs_right: Texture2D
@export var switch_rs_up: Texture2D
@export var switch_rs_down: Texture2D
@export var switch_left_trigger: Texture2D
@export var switch_right_trigger: Texture2D
@export_subgroup("Switch Buttons", "switch_")
@export var switch_bot: Texture2D
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
@export var switch_dup: Texture2D
@export var switch_ddown: Texture2D
@export var switch_dleft: Texture2D
@export var switch_dright: Texture2D
@export var switch_misc: Texture2D
@export var switch_pad1: Texture2D
@export var switch_pad2: Texture2D
@export var switch_pad3: Texture2D
@export var switch_pad4: Texture2D
@export var switch_touch: Texture2D

@export_group("Other", "other_")
@export_subgroup("Other Motions", "other_")
@export var other_ls_left: Texture2D
@export var other_ls_right: Texture2D
@export var other_ls_up: Texture2D
@export var other_ls_down: Texture2D
@export var other_rs_left: Texture2D
@export var other_rs_right: Texture2D
@export var other_rs_up: Texture2D
@export var other_rs_down: Texture2D
@export var other_left_trigger: Texture2D
@export var other_right_trigger: Texture2D
@export_subgroup("Other Buttons", "other_")
@export var other_bot: Texture2D
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
@export var other_dup: Texture2D
@export var other_ddown: Texture2D
@export var other_dleft: Texture2D
@export var other_dright: Texture2D
@export var other_misc: Texture2D
@export var other_pad1: Texture2D
@export var other_pad2: Texture2D
@export var other_pad3: Texture2D
@export var other_pad4: Texture2D
@export var other_touch: Texture2D


func get_mouse_button_texture(button_index: int) -> Texture2D:
	return get("mouse_%s"%property_map["mouse_button"][button_index - 1])


func get_gp_button_texture(category: String, button_index: int) -> Texture2D:
	return get("%s_%s"%[category, property_map["gp_button"][button_index]])


func get_gp_motion_texture(category: String, axis: int, axis_dir: String) -> Texture2D:
	return get("%s_%s"%[category, property_map["gp_motion"][axis][axis_dir]])
