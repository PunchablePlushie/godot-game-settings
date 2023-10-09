extends Node2D

@export var settings_menu_scn: PackedScene

var SettingsMenu: Control

@onready var Player: CharacterBody2D = $player
@onready var HUD: CanvasLayer = $HUD
@onready var ScoreLabel: Label = %ScoreLabel


func _ready() -> void:
	GM.score_changed.connect(_on_Global_score_changed)


func _on_Global_score_changed() -> void:
	ScoreLabel.text = "Score: %03d"%GM.score


### Pausing

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if SettingsMenu != null:
			return
		
		get_tree().paused = true
		
		SettingsMenu = settings_menu_scn.instantiate()
		SettingsMenu.confirmed.connect(_on_SettingsMenu_confirmed)
		HUD.add_child(SettingsMenu)


func _on_SettingsMenu_confirmed() -> void:
	get_tree().paused = false
