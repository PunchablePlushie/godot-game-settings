Displays the assigned [Input Confirm Window](input_confirm_window.md) when pressed and rebinds input.

Note that when set to gamepad mode, the button shows text/icon that corresponds to the currently connected gamepad device. If no gamepads are connected, it uses the "other" text/icons.

* Handles: *String\**

\* [Input Keywords](../settings/input.md#Input-Keywords) only.

## Properties
* ICW - *NodePath* : The path to the **Input Confirm Window**. Required.
* type - *int (enum)* : Input type that this component handles. Must match the *type* of the assigned input setting.
* accept_mouse - *bool* : If true, the target Input Confirm Window will accept mouse events.
* accept_modifiers - *bool* : If true, the target Input Confirm Window will accept events with modifiers.
* use_icons - *bool* : If true, and if `type` is `Gamepad`, the button displays icons instead of text.
* icon_db - *ggsGPIconDB* : The source for the gamepad icons.

## Working with ggsGPIconDB
This is a custom resource that can be used to assign textures to each gamepad motion and button. It is highly recommended to create and save this on disk and use `AtlasTexture` when setting the individual button/motion textures.
