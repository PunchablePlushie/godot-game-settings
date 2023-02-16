@tool
extends HSplitContainer

@onready var property: String = _get_property()


func _ready() -> void:
	dragged.connect(_on_dragged)
	split_offset = GGS.data.get(property)


### Private
func _get_property() -> StringName:
	return "split_offset_%s"%name.split("_")[1]


### Signals
func _on_dragged(offset: int) -> void:
	clamp_split_offset()
	GGS.data.set_data(property, offset)
