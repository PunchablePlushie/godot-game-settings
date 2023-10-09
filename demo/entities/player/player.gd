extends CharacterBody2D

@onready var NameLabel: Label = $NameLabel


func _ready() -> void:
	GM.property_changed.connect(_on_Global_property_changed)
	NameLabel.text = GM.player_name


func _physics_process(_delta: float) -> void:
	var speed: float = GM.player_speed
	var dir: Vector2
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = dir.normalized() * speed
	move_and_slide()


func _on_Global_property_changed() -> void:
	NameLabel.text = GM.player_name
