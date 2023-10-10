You can create your own custom UI components and use them just like the predefined components. UI Components use a property named `setting_value` to keep track of their current value. For example, for a simple Toggle Button, this `setting_value` can either be `true` or `false` and it corresponds to the button pressed state.

When the user interacts with the component (in our example, toggles the button), the `setting_value` is updated with the new value (in our example, the new button pressed state). Then, if `apply_on_changed` is enabled, the setting is applied (new value is saved and the setting logic is executed).

# Creating the Component Files
All components are located in your components directory (default: `game_settings/components`). 
1. Create a new folder in this directory and give it an appropriate name. You can tell GGS to ignore the folder if you start the name with an underscore (e.g. `_ignore_this`).
2. Create a new text file named `component.cfg` in the folder. This file contains information regarding the component, namely its name and icon. It should look something like this:
```ini
[component]

name = "COMPONENT_NAME"
icon = "ICON_PATH"
```
Note that providing this file is optional. Both properties are used when adding the component to the components list.

3. Create a scene in the folder. This scene *cannot* be in a subfolder and *must* be named the same thing as the folder. For example, if the folder is named `my_component`, the scene must be named `my_component.tscn`. The scripts or other secondary scenes can be in any directory (even outside of this folder) but the main scene must be a direct file of the folder.
4. The scene root *must* be a `MarginContainer`. You can add any other nodes you want to this root.
5. After creating your component, restart the plugin so you can see it in the components list.

# Adding a Script
Now, you can add a script to your root `MarginContainer` node. This script:
* *Must* extend `ggsUIComponent`.
* When overriding the following methods, you *must* first call the parent method using `super()`:
  * `_ready()`
  * `init_value()`
  * `reset_setting()`
* When the user interacts with the component, the following piece should be used:
```gdscript
setting_value = new_value
if apply_on_change:
	apply_setting()
```

# Class Methods
## init_value()
Loads `setting_value` from the assigned `setting`. Additionally, all code related to initializing the component state should go here. Example:
```gdscript
func init_value() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)
```
Remember, using `super()` when overriding this method is required. The code of the base `ggsUIComponent` class *must* be executed.

## apply_setting()
Saves the setting value to the save file and executes the setting logic. You don't generally need to override this, simply call it when you want the component to apply the setting. Always use `if apply_on_changed` condition before using it. This method is also called when a relevant **Apply Button** is pressed.

## reset_setting()
Resets the setting value back to its default and executes the setting logic. You should override this and update your component state in it. Remember to use `super()`. This method is called when a relevant **Reset Button* is pressed.

-----

Here's a simple example of a toggle button component:
```gdscript
extends ggsUIComponent

@onready var Btn: Button = $Btn


func _ready() -> void:
	super()
	Btn.toggled.connect(_on_Btn_toggled)


func init_value() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)


func _on_Btn_toggled(btn_state: bool) -> void:
	setting_value = btn_state
	if apply_on_change:
		apply_setting()


func reset_setting() -> void:
	super()
	Btn.set_pressed_no_signal(setting_value)

```
