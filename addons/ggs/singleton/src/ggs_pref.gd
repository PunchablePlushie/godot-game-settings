@tool
extends Node
## Handles saving and loading plugin preferences data.

@export var data: ggsPrefData


func _exit_tree() -> void:
	save_to_disc()


func save_to_disc() -> void:
	ResourceSaver.save(data)


func reset() -> void:
	var res_script: Script = data.get_sript()
	var properties: Array[Dictionary] = res_script.get_script_property_list()
	for property in properties:
		if property["name"] == "ggs_pref_res.gd":
			continue
		
		var default: Variant = res_script.get_property_default_value(property["name"])
		data.set(property["name"], default)
		save_to_disc()
