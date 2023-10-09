@tool
extends Node

enum Progress {SAVE_FILE_CURRENT, SAVE_FILE_DEFAULT, ADD_SETTINGS}
enum SFX {MOUSE_OVER, FOCUS, INTERACT}

signal active_category_changed()
signal active_setting_changed()
signal dir_settings_change_occured()
signal progress_started(type: Progress)
signal progress_advanced(progress: float)
signal progress_ended()

var active_category: String: set = set_active_category
var active_setting: ggsSetting: set = set_active_setting

var thread_current: Thread = Thread.new()
var thread_default: Thread = Thread.new()
var semaphore_current: Semaphore = Semaphore.new()
var semaphore_default: Semaphore = Semaphore.new()
var terminate_current: bool = false
var terminate_default: bool = false
var settings_cache: Array[ggsSetting] #?1

var FSD #!1
 
@onready var MouseOverSFX: AudioStreamPlayer = $MouseOverSFX
@onready var FocusSFX: AudioStreamPlayer = $FocusSFX
@onready var InteractSFX: AudioStreamPlayer = $InteractSFX


func _ready() -> void:
	thread_current.start(_update_save_file)
	
	if Engine.is_editor_hint():
		FSD = ggsUtils.get_file_system_dock()
		FSD.files_moved.connect(_on_FSD_item_moved)
		FSD.file_removed.connect(_on_FSD_item_removed)
		FSD.folder_moved.connect(_on_FSD_item_moved)
		FSD.folder_removed.connect(_on_FSD_item_removed)
		
		request_update_save_file()
		thread_default.start(_update_save_file_default)
	
	if not Engine.is_editor_hint():
		terminate_current = true
		semaphore_current.post()
		thread_current.wait_to_finish()
		_apply_settings()


func _exit_tree() -> void:
	terminate_current = true
	semaphore_current.post()
	thread_current.wait_to_finish()
	
	if Engine.is_editor_hint() and thread_default.is_started():
		terminate_default = true
		semaphore_default.post()
		thread_default.wait_to_finish()


func set_active_category(value: String) -> void:
	active_category = value
	active_category_changed.emit()
	active_setting = null


func set_active_setting(value: ggsSetting) -> void:
	active_setting = value
	active_setting_changed.emit()


func request_update_save_file() -> void:
	semaphore_current.post()


func request_update_save_file_default() -> void:
	semaphore_default.post()


func _update_save_file() -> void:
	while (true):
		semaphore_current.wait()
		
		call_thread_safe("emit_signal", "progress_started", Progress.SAVE_FILE_CURRENT)
		
		var save_file: ggsSaveFile = ggsSaveFile.new()
		var fresh_save: ConfigFile = ConfigFile.new()
		
		var all_settings: PackedStringArray = get_all_settings()
		var step: float = float(0)
		var total: float = float(all_settings.size())
		var progress: float
		for setting_path in all_settings:
			var setting: ggsSetting = load(setting_path)
			
			if save_file.has_section_key(setting.category, setting.name):
				var value: Variant = save_file.get_value(setting.category, setting.name)
				fresh_save.set_value(setting.category, setting.name, value)
			else:
				fresh_save.set_value(setting.category, setting.name, setting.default)
			
			step += 1
			progress = (step / total) * 100
			call_thread_safe("emit_signal", "progress_advanced", progress)
			
			if not settings_cache.has(setting):
				settings_cache.append(setting)
		
		fresh_save.save(ggsUtils.get_plugin_data().dir_save_file)
		call_thread_safe("emit_signal", "progress_ended")
		
		if terminate_current:
			break


func _update_save_file_default() -> void:
	while (true):
		semaphore_default.wait()
		
		call_thread_safe("emit_signal", "progress_started", Progress.SAVE_FILE_DEFAULT)
	
		var save_file: ggsSaveFile = ggsSaveFile.new()
		save_file.clear()
		
		var all_settings: PackedStringArray = get_all_settings()
		var step: float = float(0)
		var total: float = float(all_settings.size())
		var progress: float
		for setting_path in all_settings:
			var setting: ggsSetting = load(setting_path)
			save_file.set_value(setting.category, setting.name, setting.default)
			
			step += 1
			progress = (step / total) * 100
			call_thread_safe("emit_signal", "progress_advanced", progress)
		
		save_file.save(save_file.path)
		call_thread_safe("emit_signal", "progress_ended")
		
		if terminate_default:
			break


func _on_FSD_item_moved(old: String, new: String) -> void:
	if ggsUtils.path_is_in_dir_settings(old) or ggsUtils.path_is_in_dir_settings(new):
		dir_settings_change_occured.emit()


func _on_FSD_item_removed(item: String) -> void:
	if ggsUtils.path_is_in_dir_settings(item):
		dir_settings_change_occured.emit()


### Game Init

func get_all_settings() -> PackedStringArray:
	var all_settings: PackedStringArray
	
	var path: String = ggsUtils.get_plugin_data().dir_settings
	var dir: DirAccess = DirAccess.open(path)
	var categories: PackedStringArray = dir.get_directories()
	for category in categories:
		if category.begins_with("_"):
			continue
		
		dir.change_dir(path.path_join(category))
		var settings: PackedStringArray = _get_settings_in_dir(dir)
		all_settings.append_array(settings)
		
		var groups: PackedStringArray = dir.get_directories()
		for group in groups:
			dir.change_dir(path.path_join(category).path_join(group))
			var subsettings: PackedStringArray = _get_settings_in_dir(dir)
			all_settings.append_array(subsettings)
	
	return all_settings


func _get_settings_in_dir(dir: DirAccess) -> PackedStringArray:
	var result: PackedStringArray
	
	var settings: PackedStringArray = dir.get_files()
	for setting in settings:
		if setting.ends_with(".gd"):
			continue
		
		result.append(dir.get_current_dir().path_join(setting))
	
	return result


func _apply_settings() -> void:
	var all_settings: PackedStringArray = get_all_settings()
	for setting_path in all_settings:
		var setting: ggsSetting = load(setting_path)
		var value: Variant = ggsSaveFile.new().get_value(setting.category, setting.name)
		setting.apply(value)


### SFX

func play_sfx(sfx: SFX) -> void:
	var target_player: AudioStreamPlayer
	match sfx:
		SFX.MOUSE_OVER:
			target_player = MouseOverSFX
		SFX.FOCUS:
			target_player = FocusSFX
		SFX.INTERACT:
			target_player = InteractSFX
		_:
			printerr("GGS - Play SFX: The target SFX does not exist.")
			return
	
	if target_player.stream != null:
		target_player.play()


### Comments
# ?1: The variable `settings_cache` itself is not actually being used in
# the code. It's there to keep the references to the loaded settings
# alive.
# Godot caches loaded resources of the tree under the hood.
# View `youtube.com/watch?v=3r7IohvVnw8` for more info.

# !1: Specifying return types for the editor interface methods causes
# issues when the game is exported.
