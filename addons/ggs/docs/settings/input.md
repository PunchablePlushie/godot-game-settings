Sets an input event of a specific input action (i.e. rebinds an input).

# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| default/current | An array that stores the input type and id. The array structure is `[type, id]`. | `Array[int]`: Read-Only |
| action | The input action that holds the target input event. | `String`: Read-Only |
| event_index | The index of the target input event inside the input action. | `int`: Read-Only |
| default_as_event | The default value (an Array) as an `InputEvent`. | `InputEvent`: Read-Only |
| current_as_event | The current value (an Array) as an `InputEvent`. | `InputEvent` |

## Type and ID
Type is the type of input event such as `InputEventKey` or `InputEventJoypadMotion`. GGS uses this to create the correct type of input event when loading the setting.

ID refers to the property that stores what the actual input is. For each event type, it's as followed:
* **InputEventKey**: `physical_keycode`
* **InputEventMouseButton** & **InputEventJoypadButton**: `button_index`
* **InputEventJoypadMotion**: `axis`

## default_as_event
As mentioned, it shows the default value as an appropriate `InputEvent`. This is always the same as the input event defined in the Input Map.

> [!WARNING]
> The `default_as_event` property is read-only. However, you can still technically change it by using the "Configure" button when expanding the resource. Do not do this. If you want to change the default value, use the "Select Input" button at the top instead.

## current_as_event
It shows the current value as an appropriate `InputEvent`. You can easily change this by expanding the resource and using the "Configure" button. You can also clear it and add another type of `InputEvent` (e.g. if it's an `InputEventKey`, you can clear that and create an `InputEventMouseButton` instead).

Unlike other current/default values of other settings, the `current_as_event` property is not updated from the save file every tick as this would prevent the user from changing the resource. Instead, it's updated every time the setting is inspected. So if the `current_as_event` does not reflect what the actual `current` value is, simply re-inspect the setting.

> [!NOTE]
> The type of `InputEvent` you can create when setting `current_as_event` depends on the type of `default_as_event`. If the default is keyboard or mouse, then you can only create `InputEventKey` and `InputEventMouseButton`. If it's one of the gamepad events, you can only create a gamepad event.

> [!WARNING]
> When configuring an `InputEventKey`, use "physical keycode". GGS does not accept "keycode" and "key label".


