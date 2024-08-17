@tool
extends Node
## Handles saving and loading plugin preferences data.

@export var res: ggsPrefRes


## Saves the preferences resource.
func save_to_disc() -> void:
	ResourceSaver.save(res)


## Resets all preferences.
func reset() -> void:
	var properties: Array[Dictionary] = get_script().get_script_property_list()
	for property in properties:
		var prop_name: String = property["name"]
		if not _property_is_valid(prop_name):
			continue
		
		var default: Variant = get_script().get_property_default_value(prop_name)
		set(prop_name, default)
		save_to_disc()


func _get_preference_properties() -> Array[Dictionary]:
	var result: Array[Dictionary]
	
	var script_props: Array[Dictionary] = get_script().get_script_property_list()
	for property in script_props:
		if not _property_is_valid(property["name"]):
			continue
		
		var info: Dictionary = {
			"section": property["name"],
			"keys": get(property["name"]).keys(),
			"values": get(property["name"]).values(),
		}
		result.append(info)
	
	return result


func _property_is_valid(property_name: String) -> bool:
	if property_name == "ggs_pref.gd":
		return false
		
	if property_name.begins_with("_"):
		return false
	
	return true
