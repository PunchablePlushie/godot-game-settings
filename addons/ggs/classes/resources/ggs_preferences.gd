@tool
extends Resource
class_name ggsPreferences
## GGS preferences resource.

## Subsection behavior. View [code]quick_start.md[/code] or visit
## the documentation for more information on what subsections are.
enum SubsectionBehavior {
	## A separator is used to divide subsections and settings.
	SEPARATOR,
	
	## Subsections are converted to dictionaries.
	DICTIONARY,
}

## The file that will be used to save and load setting values during
## gameplay.[br]
## It will be saved in the user directory ([code]"user://"[/code]) and
## will be automatically created if it doesn't exist already.
@export var file_name: String = "settings.cfg"

@export_group("Subsections", "subsection_")
## How subsections are treated when saving settings.
@export var subsection_behavior: SubsectionBehavior = SubsectionBehavior.SEPARATOR

## String used as a divider when [member subsection_behavior] is 
## [enum SubsectionBehavior.SEPARATOR].
@export var subsection_seperator: String = "__"

@export_group("Paths", "path_")
## Location of invdividual game setting. This should be where your
## [ggsSetting] resource instances are.
@export_dir var path_settings: String = "res://game_settings"

## Location of setting templates. Setting templates can be used to
## create multiple instances of the same base setting.
@export_dir var path_templates: String = "res://addons/ggs/templates"
