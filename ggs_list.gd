extends Resource
class_name ggsOption

var options: Array
var current: int


func _init(options: ggsOptionSrc) -> void:
	self.options = options.source
