@tool
extends Node2D


func _ready() -> void:
	var config = ConfigFile.new()
	var input = InputEventKey.new()
	input.physical_keycode = KEY_A
	config.set_value("foo", "bar", var_to_bytes(input))
	config.save("user://test.cfg")
	
	var i2: PackedByteArray = config.get_value("foo", "bar")
	var i3: EncodedObjectAsID = bytes_to_var(i2)
	var i4: InputEventKey = instance_from_id(i3.object_id)
	print(i4.physical_keycode)
