@tool
extends HBoxContainer

const PLUGIN_CONFIG_PATH: String = "res://addons/ggs/plugin.cfg"
const REPO_PAGE: String = "https://github.com/PunchablePlushie/godot-game-settings"

var plugin_config: ConfigFile = ConfigFile.new()

@onready var VersionBtn: Button = $VersionBtn
@onready var ChangelogBtn: Button = $ChangelogBtn

func _ready() -> void:
	VersionBtn.pressed.connect(_on_VersionBtn_pressed)
	ChangelogBtn.pressed.connect(_on_ChangelogBtn_pressed)
	
	plugin_config.load(PLUGIN_CONFIG_PATH)
	_set_btns_text()


func _set_btns_text() -> void:
	var version: String = plugin_config.get_value("plugin", "version")
	VersionBtn.text = version


func _on_VersionBtn_pressed() -> void:
	var page: String = plugin_config.get_value("extra", "release")
	OS.shell_open(REPO_PAGE.path_join(page))


func _on_ChangelogBtn_pressed() -> void:
	var page: String = plugin_config.get_value("extra", "changelog")
	OS.shell_open(REPO_PAGE.path_join(page))
