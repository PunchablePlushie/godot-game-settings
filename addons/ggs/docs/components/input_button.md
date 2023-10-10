Displays the assigned [Input Confirm Window](input_confirm_window.md) when pressed and rebinds the input if the window is confirmed.

Handles array values.

# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| ICW | The path to the **Input Confirm Window**. Required. | `ConfirmationDialog` |
| accept_modifiers | Whether the Input Confirm Window should accept events with modifiers (e.g. Shift+D, Alt+M, etc.) | `bool` |
| accept_mouse | Whether the Input Confirm Window should accept mouse events. | `bool` |
| accept_axis | Whether the Input Confirm Window should accept gamepad axis inputs (e.g. left stick left, right stick up, etc.) | `bool` |
| use_icons | Whether the button should display icons instead of text for mouse and gamepad inputs. | `bool` |
| icon_db | The database for the mouse and gamepad icons. | `ggsIconDB` |

## Working with ggsIconDB
This is a custom resource that can be used to assign textures to each gamepad and mouse input. It is highly recommended to create and save this on disk and use `AtlasTexture`s when setting the individual textures. If no texture is available for an input, the button will show it as text instead.

The button shows text or icon that corresponds to the currently connected gamepad device. If no gamepad is connected (or the connected gamepad is not recognized), it uses the "other" text or icons.
