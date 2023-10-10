extends Area2D

var segments: Array[CollisionShape2D]

@onready var SpawnTimer: Timer = $SpawnTimer
@onready var LeftSegment: CollisionShape2D = $LeftSegment
@onready var RightSegment: CollisionShape2D = $RightSegment
@onready var TopSegment: CollisionShape2D = $TopSegment
@onready var BotSegment: CollisionShape2D = $BotSegment


func _ready() -> void:
	SpawnTimer.timeout.connect(_on_SpawnTimer_timeout)
	SpawnTimer.start(_get_spawn_time())
	
	segments = [LeftSegment, RightSegment, TopSegment, BotSegment]


func _get_spawn_time() -> float:
	var difficulty: int = GM.difficulty
	match difficulty:
		GM.Difficulty.EASY:
			return 3.0
		GM.Difficulty.MEDIUM:
			return 2.0
		GM.Difficulty.HARD:
			return 1.0
		GM.Difficulty.NIGHTMARE:
			return 0.5
		_:
			return 60.0


func _spawn_harm() -> void:
	var chosen_segment: CollisionShape2D = segments[randi() % segments.size()]
	chosen_segment.spawn_harm()


func _on_SpawnTimer_timeout() -> void:
	_spawn_harm()
	SpawnTimer.start(_get_spawn_time())
