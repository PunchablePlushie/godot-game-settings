extends CharacterBody2D

var dir: Vector2
var speed: float = _get_speed()

@onready var Area: Area2D = $Area
@onready var VisibilityNotifier: VisibleOnScreenNotifier2D = $VisibilityNotifier


func _init() -> void:
	set_physics_process(false)


func _ready() -> void:
	Area.body_entered.connect(_on_Area_body_entered)
	VisibilityNotifier.screen_exited.connect(_on_VisibilityNotifier_screen_exited)
	
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	move_and_collide(dir * speed * delta)


func _get_speed() -> float:
	var difficulty: int = GM.difficulty
	match difficulty:
		GM.Difficulty.EASY:
			return 350.0
		GM.Difficulty.MEDIUM:
			return 400.0
		GM.Difficulty.HARD:
			return 550.0
		GM.Difficulty.NIGHTMARE:
			return 700.0
		_:
			return 0.0


func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()


### Collision

func _on_Area_body_entered(_body: Node2D) -> void:
	GM.score = max(0, GM.score - 5)
	
	set_physics_process(false)
	queue_free()
