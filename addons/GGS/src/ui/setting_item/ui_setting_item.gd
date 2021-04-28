tool
extends HBoxContainer

# SceneTree
onready var SettingName: Label = $Name
onready var EditBtn: Button = $HBox/Edit
onready var ScriptBtn: Button = $HBox/Script
onready var RemoveBtn: Button = $HBox/Remove


func _ready():
	EditBtn.hint_tooltip = "Edit Properties"
	ScriptBtn.hint_tooltip = "Logic Script"
	RemoveBtn.hint_tooltip = "Remove"
