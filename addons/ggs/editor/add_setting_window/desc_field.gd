@tool
extends RichTextLabel


func set_content(item: ggsSetting) -> void:
	var item_name: String = item.name
	var item_desc: String = item.desc
	text = "[color=white]%s[/color]: %s"%[item_name, item_desc]


func clear_content() -> void:
	text = "[color=dim_gray]Choose an item to see what it does.[/color]"
