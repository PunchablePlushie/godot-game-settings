tool
extends HBoxContainer

var initialized: bool = false

# SceneTree
onready var IndexField: LineEdit = $Index
onready var NameField: LineEdit = $NameField
onready var DefaultType: OptionButton = $HBox/DefaultType
onready var DefaultField: LineEdit = $HBox/DefaultField
onready var EditScriptBtn: Button = $HBox/EditScript
onready var AddScriptBtn: Button = $HBox/AddScript
onready var RemoveBtn: Button = $HBox/Remove
