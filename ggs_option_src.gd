extends Resource
class_name ggsOptionSrc

var source: Array
var targets: Array[String]

# Use a custom EditorProperty to edi this object's source property.
# When the source property is changed^1
# 1. Save the new ggsOptionSrc.
# 2. Go through the objects^2 property list and find the properties that are in
# 	the 'targets' property.
# 3. For each one, create a new ggsOption with the new ggsOptionSrc.
# 4. Make inspector refresh the property editors of the properties in 'targets'.


#1 we can react to this with EP's built-in signals.
#2 we can get the edited object with get_edited_object from EP.
