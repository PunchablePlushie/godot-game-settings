A group of buttons. Only one button can be selected at any time.

Handles integer and boolean values.

# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| option_ids | The list of option IDs. | `PackedInt32Array` |
| active_list | The `BoxContainer` that will be used. | `PackedInt32Array` |

## Adding Options
You can add `Button`s or `CheckButton`s to the active list. All buttons must have `toggle_mode` enabled. The index of the button node in the active list is the index of the option (e.g. the first button returns `0`, the second one returns `1`, and so on) unless `option_ids` is not empty.

## option_ids
This is the list of IDs associated with each option. Each item in this array corresponds to the button node with the same index in the active list. If this property is set, the component returns the item ID instead of its index. If you don't want to use IDs, simply leave this as empty.

> [!NOTE]
> If you want to use item IDs, both `option_ids` and the number of button nodes in the active list must be the same size.
