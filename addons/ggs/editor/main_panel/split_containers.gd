@tool
extends HSplitContainer

@onready var property: String = _get_property()


func _ready() -> void:
	dragged.connect(_on_dragged)
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	split_offset = data.get(property)


### Private
func _get_property() -> StringName:
	return "split_offset_%s"%name.split("_")[1]


### Signals
func _on_dragged(offset: int) -> void:
	clamp_split_offset()
	
	var data: ggsPluginData = ggsUtils.get_plugin_data()
	data.set_data(property, offset)
