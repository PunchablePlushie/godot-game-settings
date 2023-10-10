# I Can't Add Categories or Generally Use the Plugin After Installation
When you first install the plugin, Godot might output the following error:
```
Parse Error: Identifier "GGS" not declared in the current scope.
```
This means that the GGS singleton doesn't exist. When the plugin is first added, Godot tries to parse the scripts and since the singleton doesn't exist at that point (since the plugin is not enabled yet), it'll throw that error. The plugin will not function properly even after you add the singleton to the project. To fix it:
1. Make sure the singleton is added in the autoload list (Project Settings → Autoload) and it's enabled.
2. Reload the project.

Note that the plugin adds the singleton automatically when enabled. If for some reason it doesn't, you can find the script at the following path:
```
res://addons/ggs/classes/ggs_globals.gd
```
Simply add that script to the autoload list, **name it GGS**, and reload the project.


# Input Button doesn't Show the Correct Gamepad Icon/Text
The input button component shows the icon/text that corresponds to the currently connected gamepad device (i.e. Xbox, PlayStation, Switch, etc.). When no device is connected, it uses "other" labels and icons.

For labels, you can view/edit them in `ggsInputHelper.gd`/`gamepad_labels["other"]`.

For icons, you can set the `other_*` properties of the `ggsGPIconDB` that you've assigned to the button.

# Custom Setting not Showing Up in the New Setting Window
Make sure your script is a `@tool` script and extends `ggsSetting`. If you don't plan to give your setting a name, call `super()` in its `_init()` method so it grabs the default values from the base `ggsSetting` class. Lastly, make sure you reload the list when New Setting Window is open. The reload button is located to the right of the search field.
It's also recommended to reload the list whenever you change the code of a setting.


# UI Component Error
```
Invalid type in function <some_function> in base <some_class>. Cannot convert argument 1 from Nil to <some_type>.
```
If you get the above error or something similar in nature, consider checking the `setting` property of all of your instantiated UI components. GGS doesn't automatically take care of deleted setting resources. It just resets their script to the base `ggs_setting.gd` script. Both `current` and `default` properties of the base `ggsSetting` are `null`. So:
1. Make sure all of the instantiated UI components have a valid setting that's not a `[Deleted Setting]`.


# Setting Properties are not Editable
It's not clear why this exactly happens. But if it happens try:
1. Select a setting in another category.
2. Restart the plugin.
3. Restart the editor.

If #1 one doesn't fix the issue, #2 should fix it 99% of the times.

# Plugin Data in Use / Safe Save Error
```
Safe save failed. This may be a permissions problem, but also may happen because you are running a paranoid antivirus.
If this is the case, please switch to Windows Defender or disable the 'safe save' option in editor settings. This makes
it work, but increases the risk of file corruption in a crash.
```
Sometimes when exporting the project, Godot might give the above error multiple times during the export process. Unfortunately, I'm unclear on what the source of it is exactly. This seems to be especially prevalent in Windows. If you encountered this during the export process:
1. Restart the project and try again. Consider exporting the game before doing anything else in the project.
2. Temporarily disable your anti-virus.
3. Let Godot finish the process. It'll take a few seconds but Godot will be able to finish the export process. The exported executable should still work properly and all settings should function.
4. Disable Safe Save in the Editor Settings. Doing so you will no longer guarantee that files will be fully written by Godot (in the event of a crash or power failure). 

Please open an issue if you know the source of the issue or know how to solve it.

# Setting Type Error
```
Invalid type in function 'apply' in base 'Resource ()'. Cannot convert argument 1 from <somet_type> to <some_other_type>.
>>> ggs_globals.gd:63
```
When launching the game, you may encounter the above error, which leads to `ggs_globals.gd` line `63`. If so, check your setting scripts. Make sure the type the `apply()` method receives is correct. For example, your `apply()` method might expect a `bool` value but it's receiving a `String`.
