You can create your own custom settings and templates in GGS.

# Setting up a Custom Setting
When you add a setting via the *New Setting...* field, you create a blank setting with no logic or properties. In order to use it, you need to set up it properly.

## The `value_type`
To start, select your newly created blank setting. You may notice that the `current` and `default` values are `null`. This is because the `value_type` property has not been set. Open the `Internals` group and choose an appropriate value type for your setting from the drop-down menu. You can optionally choose `value_hint` and `value_hint_string`. These are used to customize the export behavior of the `current` and `default` values.

For example, if your `value_type` is `float`, you can set `value_hint` to be `Range`. And set `value_hint_string` to be `0,100`. This will export `default` and `current` properties as a range between `0` and `100`. For more information, view `_get_property_list()` and `Property.Hint` constants in the Godot docs.

Once you've set the `value_type` select the setting again to reinspect it. Now you can see the `default` and `current` value are exported correctly.

## The Logic
To write the logic for your setting, you need to edit its script. You can do so by:
* Either open the `script` property in the Inspector. Under the `RefCounted` category.
* Directly open the script in the file system.

As you can see, there are a few prerequisites for the script. The script *must*:
* Be a `@tool` script.
* Extend `ggsSetting`.
* Have a method called `apply()`.

The `apply()` method is where your logic should go. It must take a value (the same type defined in `value_type`).

Here's a simple example of a VSync setting:

```gdscript
@tool
extends ggsSetting


func apply(value: bool) -> void:
	var vsync_mode: DisplayServer.VSyncMode
	match value:
		true:
			vsync_mode = DisplayServer.VSYNC_ENABLED
		false:
			vsync_mode = DisplayServer.VSYNC_DISABLED
	
	DisplayServer.window_set_vsync_mode(vsync_mode)
```

That's the core of what you need to do. You can define variables, other methods, etc. in the script.

# Templates
Creating a template is essentially the same as setting up the script of a blank setting. To start, create a script in your templates directory. The script must fulfill all three conditions explained previously but it has one additional condition:
* The script must override the `_init()` method and set `value_type` and `default` in there. You can also set `value_hint` and `value_hint_string` if applicable.

That's the only additional criterion you have to keep in mind. Everything else is the same as mentioned previously.

Check out some of the predefined templates to see a few examples of what you can do.
