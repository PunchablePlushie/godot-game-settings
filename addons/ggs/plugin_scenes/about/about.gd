@tool
extends AcceptDialog

const _BASE_URL: String = "https://"

@export_group("URLs", "_url_")
@export var _url_doc: String
@export var _url_issues: String
@export var _url_changelog: String

@export_group("Nodes")
@export var _DocBtn: Button
@export var _IssuesBtn: Button
@export var _ChangelogBtn: Button


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_DocBtn.pressed.connect(_on_DocBtn_pressed)
	_IssuesBtn.pressed.connect(_on_IssuesBtn_pressed)
	_ChangelogBtn.pressed.connect(_on_ChangelogBtn_pressed)
	
	get_ok_button().hide()


func _on_visibility_changed() -> void:
	if not visible:
		queue_free()


func _on_DocBtn_pressed() -> void:
	OS.shell_open(_BASE_URL + _url_doc)


func _on_IssuesBtn_pressed() -> void:
	OS.shell_open(_BASE_URL + _url_issues)


func _on_ChangelogBtn_pressed() -> void:
	OS.shell_open(_BASE_URL + _url_changelog)
