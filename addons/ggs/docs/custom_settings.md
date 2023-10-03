You can create your own custom settings in GGS and add them to categories just like the predefined settings.

# Basic Custom Setting
To create a custom setting, simply create a new script in your settings directory (default: `game_settings/settings`). This script *must*:
* Be a `@tool` script
* Extend `ggsSetting`
* Override `_init()`. Inside this method:
  * You *can* set `name`, `icon`, and `desc` of the setting. If you don't plan to provide any of them or only some of them, you should use `super()` before setting those properties so the default values from the base `ggsSetting` class are used instead.
  * You *must* set the `value_type` of the setting. This is the type of `default` and `current` and can be any of the `Variant.Type` constants (e.g. TYPE_BOOL, TYPE_STRING, TYPE_VECTOR2, etc.)
  * You *can* provide an initial `default` value for the setting.
  * You *can* use `value_hint` and `value_hint_string` to customize the export behavior. See `PropertyHint` constants for more information (e.g. PROPERTY_HINT_ENUM, PROPERTY_HINT_RANGE, etc.)
* It must define a function named `apply(value)`. This is where the setting logic goes.

You can add anything to the script as long as the aforementioned conditions are true.

After you're done with your script, open the New Setting Window and reload the list. The reload button is located on the right side of the search field. GGS caches the settings list so it doesn't take ages for the New Setting Window to show up. By reloading the list, you reload the settings from the disk and update the cache. It's recommended to also reload the list whenever you change the code of a setting.

### Example
Here's a simple setting that handles toggling VSync on and off.
```gdscript
@tool
extends ggsSetting


func _init() -> void:
	super()
	name = "VSync Mode"
	
	value_type = TYPE_BOOL
	default = true


func apply(value: bool) -> void:
	var vsync_mode: DisplayServer.VSyncMode
	match value:
		true:
			vsync_mode = DisplayServer.VSYNC_ENABLED
		false:
			vsync_mode = DisplayServer.VSYNC_DISABLED
	
	DisplayServer.window_set_vsync_mode(vsync_mode)

```

Here's an example for game difficulty:
```gdscript
@tool
extends ggsSetting

enum Difficulty {Easy, Medium, Hard}


func _init() -> void:
	super()
	name = "Difficulty"
	
	value_type = TYPE_INT
	default = Difficulty.Medium
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = "Easy,Medium,Hard"


func apply(value: Difficulty) -> void:
	# Logic goes here
```

# Using Extra Properties
There are many cases when a single value is not enough for a setting and you need some extra pieces of information to apply a setting. For example, when setting the volume for an audio bus, you also need the bus name in addition to the new volume.
You can `@export` properties for these cases and use those properties when needed. There's only one requirement: Your property must have a setter and inside that setter, you should use the following piece:
```gdscript
if is_added():
	save_plugin_data()
```
This will make sure that the plugin data is updated with the new value of your property whenever you change it. The `is_added()` check makes sure that it only happens when the setting is actually added to a category (i. e. is part of a category).

You can check predefined settings `input.gd` or `audio_mute.gd` for some examples of this.

-----

In addition to using `@export`, you can use `_get_property_list()` for a more customized export behavior. Check `audio_mute.gd` or `display_fullscreen.gd` for some examples of this. Do note that `_get_property_list()` is a Godot function. For more information on how to use it, look it up in the Godot documentation.
