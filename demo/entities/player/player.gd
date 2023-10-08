extends CharacterBody2D

@export var speed: float = 400.0

var can_move: bool = true


func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	
	var dir: Vector2
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = dir.normalized() * speed
	move_and_slide()
