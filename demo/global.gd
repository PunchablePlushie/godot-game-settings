extends Node
signal property_changed()
signal score_changed()

enum Difficulty {EASY, MEDIUM, HARD, NIGHTMARE}

@export var player_name: String = "Ristar": set = set_player_name
@export var player_speed: float = 400.0
@export var difficulty: Difficulty = Difficulty.MEDIUM

var score: int: set = set_score

@onready var ScoreTimer: Timer = $ScoreTimer


func _ready() -> void:
	ScoreTimer.timeout.connect(_on_ScoreTimer_timeout)


func set_player_name(value: String) -> void:
	player_name = value
	property_changed.emit()


func set_score(value: int) -> void:
	score = value
	score_changed.emit()


func _on_ScoreTimer_timeout() -> void:
	score += 1
