A list that allows cycling through options using two arrows on the left and right.

Handles integer and boolean values.

# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| options | The list of options. | `PackedStringArray` |
| option_ids | The list of option IDs. | `PackedInt32Array` |

## option_ids
This is the list of IDs associated with each option. Each item in this array corresponds to the item with the same index in the `options` array. If this property is set, the component returns the item ID instead of its index. If you don't want to use IDs, simply leave this as empty.

Example:

Let's say your setting sets the number of power-ups the player character starts with.
```gdscript
option = ["low", "medium", "high"]
option_ids = [5, 10, 20]
```

> [!NOTE]
> If you want to use item IDs, both `options` and `option_ids` must be the same size.
