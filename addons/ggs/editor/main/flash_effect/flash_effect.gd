@tool
extends ColorRect

@export_group("Nodes")
@export var AnimPlayer: AnimationPlayer


func _ready() -> void:
	AnimPlayer.play("RESET")


func run() -> void:
	AnimPlayer.play("flash")
