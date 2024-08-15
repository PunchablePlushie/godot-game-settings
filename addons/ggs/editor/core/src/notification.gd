@tool
extends AcceptDialog

enum Purpose {INVALID, ALREADY_EXISTS}

@export_group("Title", "title_")
@export var title_invalid: String
@export var title_already_exists: String
@export_group("Message", "msg_")
@export_multiline var msg_invalid: String
@export_multiline var msg_already_exists: String


var purpose: int : set = set_purpose


func set_purpose(value: int) -> void:
	purpose = value
	
	match value:
		Purpose.INVALID:
			title = title_invalid
			dialog_text = msg_invalid
		Purpose.ALREADY_EXISTS:
			title = title_already_exists
			dialog_text = msg_already_exists
