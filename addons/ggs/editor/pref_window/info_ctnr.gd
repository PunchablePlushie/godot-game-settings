@tool
extends HBoxContainer

const PLUGIN_CONFIG_PATH: String = "res://addons/ggs/plugin.cfg"
const URL_CHANGELOG: String = "https://github.com/PunchablePlushie/godot-game-settings/tree/main/docs/changelog.md#"
const URL_RELEASES: String = "https://github.com/PunchablePlushie/godot-game-settings/releases/tag/"

var version: String
var plugin_config: ConfigFile = ConfigFile.new()

@onready var VersionBtn: Button = $VersionBtn
@onready var ChangelogBtn: Button = $ChangelogBtn


func _ready() -> void:
	VersionBtn.pressed.connect(_on_VersionBtn_pressed)
	ChangelogBtn.pressed.connect(_on_ChangelogBtn_pressed)
	
	plugin_config.load(PLUGIN_CONFIG_PATH)
	
	version = plugin_config.get_value("plugin", "version")
	VersionBtn.text = version


func _on_VersionBtn_pressed() -> void:
	OS.shell_open(URL_RELEASES + version)


func _on_ChangelogBtn_pressed() -> void:
	OS.shell_open(URL_CHANGELOG + version.replace(".", ""))
