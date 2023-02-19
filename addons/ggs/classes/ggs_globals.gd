@tool
extends Node

### Signals

signal category_selected(category: ggsCategory)
signal setting_selected(setting: ggsSetting)
signal setting_property_changed(setting: ggsSetting, value: String)


### Variables

var data: ggsPluginData = preload("../plugin_data.tres")
var active_category: ggsCategory
var active_setting: ggsSetting


### Private

func _ready() -> void:
	category_selected.connect(_on_category_selected)
	setting_selected.connect(_on_setting_selected)


func _on_category_selected(category: ggsCategory) -> void:
	active_category = category


func _on_setting_selected(setting: ggsSetting) -> void:
	active_setting = setting

