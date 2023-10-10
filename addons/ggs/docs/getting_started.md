This guide will show you how to get started with GGS and create a setting menu with all the predefined settings and components.

# Installation
* You can install the plugin through the Asset Library inside the editor.
* You can also pull the repository with Git, or download the `main` branch directly with something like [DownGit](https://minhaskamal.github.io/DownGit/#/home).

> Note: The plugin may not work when first installed. Follow [this](troubleshoot.md#i-cant-add-categories-or-generally-use-the-plugin-after-installation) troubleshoot guide to fix it if you encounter the issue.

# GGS Editor
When enabled, GGS adds a bottom panel editor to Godot named "Game Settings". The editor is divided into 3 panels:
* The category panel on the left.
* The setting panel in the center.
* The component panel on the right.

# Categories
To add settings, you should first add categories. Categories can be anything such as "Audio", "Display", "Input", "Accessibility", etc. Each category corresponds to a section in the save file.

To add a category, write the name of the category in the field above the category list. Press **ENTER** or click the **+** button to add the category to the list. You can use any character and format for the name but using snake_case is recommended.

To rename a category, simply double-click on it.

To remove a category, right-click on the target category and selected **Delete**.

You can also **Inspect** a category as they are just resources. However, as a user, you may not find much use in this as this feature is mostly for debugging.


# Settings
Settings are resources that contain everything a setting needs to function such as its properties and logic. They're located in `game_settings/settings`. Each setting corresponds to a key in the save file.

To add a setting to a category, select the desired category, then press the **+** button above the settings list. Choose your desired setting from the list and click **Add** (double-clicking the item works as well).

To rename a setting, simply double-click on it. You can use any character and format for the name but using snake_case is recommended.

Now that you have added your setting, you can click on it to edit its properties. Each predefined setting has its own properties and while they're mostly self-explanatory, you can visit the [Settings](settings/settings.md) page to see what each setting does and what each property means.

All settings have two common properties regardless, however. The `default` and `current` properties refer to the default and current value of the setting respectively.
* The `default` value is used when no current value is available (e.g. when the setting doesn't have an entry in the save file). Or when the setting is reset to default using the **Reset Button** component.
* The `current` value indicates the current value of the setting in the save file. Changing it from the editor updates the save file. Does not do anything when the game is running.

You may notice the group **Internals**. These properties are read-only and mainly used for easier debugging.

You can create your own custom settings with their own custom name, icon, description, logic, and properties. Visit [Custom Settings](custom_settings.md) for more information.

# UI Components
The UI components are what the user can interact with to change a setting. They're located at `game_settings/components`. You can assign a setting to each component. When the component is interacted with, it'll update the save file with the new value and execute the logic of the assigned setting.

Each component has a property name `apply_on_changed`. If set to `true`, the component will apply the setting (update save file + execute setting logic) when the user interacts with it. If false, you need to use the **Apply Button** to apply the setting and save changes.

To add a new component, select a setting and a *single* node in the scene tree of your target scene. Then, simply double-click a component in the component list to instantiate a component of that type.

> **Warning**: GGS does not keep track of the assigned setting of the components. Meaning, that if you delete a setting that's assigned to a component, that component will still have the deleted setting assigned to it. Running the project with a component that has a `[Deleted Setting]` will cause an error. So remember to keep component settings updated and valid.

Each component can only handle a specific type of data. An **Arrow List** for example, can only handle integers while a **Slider** can only handle floats.

It is possible to use certain components with multiple types. For instance, you can use an **Arrow List** for a setting that accepts boolean values if you configure the arrow list to have only 2 items: The first one being the "false" or "disabled" option and the second one being the "true" or "enabled" option.

You can create your own custom UI components. Visit [Custom Components](custom_components.md) for more information.

# Conclusion
That's all you need to know to use GGS. Other options or features are self-explanatory or have tooltips that you can read. If you were ever unclear about how to use a specific predefined setting or component, check their individual documentation page. Check the [Troubleshoot](troubleshoot.md) page for a list of common issues that you may encounter and potential solutions for them.

Feel free to open an issue if you need further assistance with the plugin, encounter a bug, or would like some additional features.
