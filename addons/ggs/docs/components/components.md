UI components are nodes that can be added to your settings menu and allow players to change a setting.

# Properties
All components have several properties that are shared among them.
| Property | Description | Type |
| :---: | --- | :---: |
| setting | The setting that's assigned to the component. The setting's value type must be compatible with the types the component handles. | `ggsSetting` |
| apply_on_changed | Whether the component should apply the setting when the player interacts with it. If false, you should apply the settings with an [Apply Button](apply_button.md) component. | `Bool`|
| grab_focus_on_mouse_over | Whether the component should grab focus on mouseover. Useful if your game supports both keyboard and mouse. | `Bool` |

# Setting Sound Effects
You can set sound effects to be played when the player mouses over the components, interacts with them, or the components grab focus.

First, you should open the `ggs.tscn` scene. To do so:
* Open the scene via the Preferences in the GGS editor.
* Open the scene using the *Quick Open Scene...* option in Godot editor.
* Manually open the scene. The scene is located at `res://addons/ggs/classes/global/ggs.tscn`

This scene is the same scene that's added to the autoload list. Once the scene is open, assign an audio stream to each of the available audio stream players under the root `GGS` node.

# Predefined Components
GGS comes with the following predefined components:
* [Binary Selection](binary_selection.md)
* [Arrow List](arrow_list.md)
* [Option List](option_list.md)
* [Radio List](radio_list.md)
* [Slider](slider.md)
* [SpinBox](spinbox.md)
* [Text Field](text_field.md)
* [Input Button](input_button.md)
* [Input Confirm Window](input_confirm_window.md)
* [Apply Button](apply_button.md)
* [Reset Button](reset_button.md)
