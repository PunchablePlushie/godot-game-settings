@tool
extends PanelContainer

@export_multiline var label_save_file_current: String
@export_multiline var label_save_file_default: String
@export_multiline var label_add_multiple_settings: String

var type: int

@onready var ProgLabel: Label = %ProgLabel
@onready var ProgBar: ProgressBar = %ProgBar


func _ready() -> void:
	GGS.progress_started.connect(_on_Global_progress_started)
	GGS.progress_advanced.connect(_on_Global_progress_advanced)
	GGS.progress_ended.connect(_on_Global_progress_ended)
	
	visible = false
	ProgBar.value = 0


func _on_Global_progress_started(progress_type: int) -> void:
	visible = true
	ProgBar.visible = true
	type = progress_type
	
	match type:
		GGS.Progress.SAVE_FILE_CURRENT:
			ProgLabel.text = label_save_file_current
		GGS.Progress.SAVE_FILE_DEFAULT:
			ProgLabel.text = label_save_file_default
		GGS.Progress.ADD_SETTINGS:
			ProgLabel.text = label_add_multiple_settings
			ProgBar.visible = false
	


func _on_Global_progress_ended() -> void:
	# A small delay to make sure progress_ended happens after progress_started
	await get_tree().create_timer(0.01).timeout
	
	visible = false
	ProgBar.value = 0


func _on_Global_progress_advanced(progress: float) -> void:
	ProgBar.value = progress
