@tool
extends Node
## Handles saving and loading plugin preferences data.

@export var res: ggsPrefRes


func _exit_tree() -> void:
	save_to_disc()


## Saves the preferences resource.
func save_to_disc() -> void:
	ResourceSaver.save(res)


## Resets all preferences.
func reset() -> void:
	var res_script: Script = res.get_sript()
	var properties: Array[Dictionary] = res_script.get_script_property_list()
	for property in properties:
		if property["name"] == "ggs_pref_res.gd":
			continue
		
		var default: Variant = res_script.get_property_default_value(property["name"])
		res.set(property["name"], default)
		save_to_disc()
