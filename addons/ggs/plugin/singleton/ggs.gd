@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

@export var Pref: ggsPreferences

@export_group("Nodes")
@export var Events: Node
@export var GameConfig: Node


func _ready() -> void:
	var config_file: String = Pref.path_file
	if not FileAccess.file_exists(config_file):
		ConfigFile.new().save(config_file)
