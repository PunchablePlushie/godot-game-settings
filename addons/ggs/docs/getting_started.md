This guide will show you how to create a basic settings menu with the predefined settings and components that come with GGS.

# Installation
You can install the plugin through various ways, including:
* Install the plugin through the Asset Library inside the Godot editor.
* Clone the repository with Git.
* Download the latest release.
* Download the `main` branch directly with [DownGit](https://minhaskamal.github.io/DownGit/#/home) or similar tools.
* Add the `main` branch as a Git Submodule. [Learn more about Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

> [!IMPORTANT]
> No matter how you download the `main` branch (via releases, DownGit, or as a Git submodule), you should copy the contents of the *_premade* folder and paste them into your own game settings directory. You can change these directories in Preferences.
> Example:
> ```
> res://
>   └ game_settings
>       └ components
>       └ settings
>       └ templates
> ```

> [!NOTE]
> The plugin may not work as expected when added to a project at first. Enable the plugin through the Project Settings then restart the Godot editor. [More information](troubleshoot.md#can't-use-the-plugin-after-installation).

# GGS Editor
When enabled, GGS adds a bottom panel editor to Godot named "Game Settings". The editor is divided into 3 panels:
* The categories panel on the left.
* The settings panel in the center.
* The components panel on the right.

# Categories
To add settings, you should first add categories. To do so, simply enter a valid name in the *New Category...* field at the top of the categories panel and press ENTER.
A valid category name is:
1. A valid file name (does not have unsupported special characters such as `@`, `?`, `!`, etc., and does not start or end with trailing space).
2. Does not start with an underscore (`_`) or a dot (`.`). Underscores are used to tell GGS to ignore a directory. Dots do the same but for Godot's file system.
3. While not necessary, I recommend using snake_case to follow Godot's recommended styling guidelines.

After doing that, you may notice a folder is added to the settings directory (`res://game_settings/settings` by default) in the file system. All folders that are *direct* children of the settings directory will be considered categories. If you want GGS to ignore a folder, add an underline to the beginning of its name (e.g. `_ignore_this`).

## Renaming Categories

To rename a category, simply rename its folder from the Godot file system.

## Deleting Categories

To delete a category, simply delete its folder from the Godot file system. Depending on your system settings, this will either permanently delete the folder or move it to the recycle bin.

> [!WARNING]
> Do not rename or delete files and folders from your OS file system in general. This can cause issues with references in Godot. Use Godot's own file system to do so.

# Settings
Settings are resources that contain the logic and properties of a game setting. For example, the audio volume setting contains the name of an audio bus, the current and default values for it, and how Godot is supposed to change the volume of said bus.

There are two methods of adding settings: Adding blank settings and adding settings from a template.

## Adding Blank Settings
This method is useful when you want to create a single unique setting. For example, if you want to add a difficulty option, you can use this method as a game usually has only one difficulty option.

To add a blank setting with no properties and logic, use the *New Setting...* field at the top of the settings panel. Enter a valid name (the validation is the same as category names) and press ENTER to add a new setting to the currently selected category. If one or more groups are selected, a setting is added to each selected group.

When you create a setting via this method, GGS creates a new `ggsSetting` resource and saves it on your disc inside the category folder. It then duplicates the blank template script and assigns it to said resource.

> [!NOTE]
> You can edit this blank template script from preferences.

## Adding Settings from Templates
There are times when a type of setting must be used multiple times. The easiest example is an input setting. A game usually has multiple inputs and you need a setting resource for each individual input. The logic behind *how* an input should be changed is the same among all of them. The only thing that changes is the input action they should change (in other words, a property).

This is where templates come into play. You can add settings from templates to create multiple settings with the same logic and properties that can be changed via the inspector.

To add a setting from a template, use the `+` button. This will open a window that shows all the available templates located in the templates directory (`res://game_settings/templates` by default). Simply double-click a template, give the setting a valid name, and press ENTER or press the *Add* button.

This method is essentially the same as the first one when it comes to the actual creation process, except that instead of assigning a blank script to the resource, it assigns the specific template script that you selected.

## Inspecting Settings
To inspect a setting, click on it in the settings panel. This will show its `current` and `default` values along with any additional properties it might have in the Godot Inspector. You can also view its script all the way down via the `script` property under `RefCounted`.

The properties inside the `Internal` group are internal properties used by GGS to handle the setting. These are explained further in [Creating Custom Settings](custom_settings.md).

You can also right-click on a setting to highlight in the Godot file system.

## Groups
As implied previously, you can add settings to groups. Groups can help you add settings faster and tidy up your category.

To add a group, enter a valid name in the *New Group...* field and press ENTER.

To add settings to a group, click on it to select it. When adding settings via any of the aforementioned methods, GGS will add a setting to every selected group. Do note that adding settings to a high number of groups can take a few moments. Godot will be unresponsive during this time.

## Deleting and Renaming
You can rename, delete, or move settings and groups in the file system similar to categories. 

## Custom Settings
To learn how you can set up your own custom settings and templates, view [Creating Custom Settings](custom_settings.md).

For more info on the predefined settings, visit [Settings](settings/settings.md).


# UI Components
The UI components are what the user can interact with to change a setting. They're located at `game_settings/components`. You can assign a setting to each component. When the component is interacted with, it'll update the save file with the new value and execute the logic of its assigned setting.

Each component has an `apply_on_changed` property. If set to `true`, the component will apply the setting (update save file + execute setting logic) when the user interacts with it. If false, you need to use an **Apply Button** to apply the setting and save changes.

To add a new component, select a setting and a *single* node in the scene tree of your target scene. Then, simply double-click a component in the component list to instantiate a component of that type.

Each component can only handle a specific type of data. An **Arrow List** for example, can only handle integers while a **Slider** can only handle floats.

It is possible to use certain components with multiple types. For instance, you can use an **Arrow List** for a setting that accepts boolean values if you configure the arrow list to have only 2 items: The first one being the "false" or "disabled" option and the second one being the "true" or "enabled" option.

## Custom Components
To learn how you can create your own custom components, view [Creating Custom Components](custom_components.md).

For more info on the predefined components, visit [Components](components/components.md).

---

Feel free to open an issue to ask for help, report a bug, or suggest additional features or QoL enhancements.
