tool
extends HBoxContainer

# SceneTree
onready var IndexField: LineEdit = $Index
onready var NameField: LineEdit = $NameField
onready var EditScriptBtn: Button = $HBox/EditScript
onready var AddScriptBtn: Button = $HBox/AddScript
onready var RemoveBtn: Button = $HBox/Remove
onready var MainPanel: Control = get_node("../../../../../..")
