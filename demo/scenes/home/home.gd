extends Node2D

@export var settings_menu_scn: PackedScene

var SettingsMenu: Control

@onready var Player: CharacterBody2D = $player
@onready var HUD: CanvasLayer = $HUD


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if SettingsMenu != null:
			return
		
		Player.can_move = false
		
		SettingsMenu = settings_menu_scn.instantiate()
		SettingsMenu.confirmed.connect(_on_SettingsMenu_confirmed)
		HUD.add_child(SettingsMenu)


func _on_SettingsMenu_confirmed() -> void:
	Player.can_move = true
