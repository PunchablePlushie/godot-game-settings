@tool
extends ggsGroup

@export_category("Audio Group")
@export var bus_name: String


func _init() -> void:
	name = "Audio Group"
	icon = preload("res://addons/ggs/assets/game_settings/groups/audio_group.svg")
	desc = "Group audio settings of a specific audio bus."
