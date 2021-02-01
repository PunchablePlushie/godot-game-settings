extends Node

export(String) var file_path: String = "res://settings.cfg"
export(String, FILE, "*.cfg") var default_file: String
export(bool) var use_audio_system: bool = false
export(AudioStream) var select_sfx: AudioStream
export(AudioStream) var focus_sfx: AudioStream
export(AudioStream) var error_sfx: AudioStream

var _config: ConfigFile = ConfigFile.new()
var _sections: Array = []
var _keys: Dictionary = {}
var _sfxs: Array = []

onready var audio_player: AudioStreamPlayer = $AudioPlayer

func _ready() -> void:
	_sfxs = [select_sfx, focus_sfx, error_sfx]
	var error = _config.load(file_path)
	if error != OK:
		_config.load(default_file)


func get_setting(section: String, key: String):
	return _config.get_value(section, key, null)


func set_setting(section: String, key: String, value) -> void:
	_config.set_value(section, key, value)
	_config.save(file_path)


func play_sfx(type: int) -> void:
	if use_audio_system == false:
		return
	
	if _sfxs[type] == null:
		var message: String = "QGS-ERR-> No audio stream is defined for type %s" % [type]
		push_error(message)
		return
	audio_player.stream = _sfxs[type]
	audio_player.play()
