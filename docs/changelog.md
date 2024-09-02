## 3.1.0
This version completely reworks how the categories and settings are stored, and adds several QoL features to the plugin.

### General
* Categories and Settings are now saved on the disc instead of being subresources of the plugin data. This allows more flexibility when handling them such as moving, renaming, and deleting.
* Icon and description support for settings and components have been removed. While this was a "cool" feature, it didn't add anything significant and just added to the code bloat since I don't think people would actually spend time designing icons and writing descriptions for their own custom settings.
* The plugin now applies settings (executes their logic) using a separate thread instead of doing it on the main thread.
* The preferences window now includes a button for updating the plugin theme to reflect the theme of your own Godot editor.
* The preferences window has been slightly redesigned for clarity.
* A "Send Feedback" button has been added which takes you to a Google survey where you can provide feedback regarding the plugin. You can still request features and QoL changes using issues on GitHub.
* Options were added to the Save File menu that allow you to remake the save file from either `current` or `default` values.

### Settings
* The settings panel UI has been reworked.
* You can now group settings in a category for organization. Additionally, you can add settings to multiple groups at the same time, speeding up the process of adding settings to a category.
* The way custom settings are created and added has been slightly changed and streamlined.
* The predefined settings (previously in the settings directory) are now considered to be templates.
* The templates directory (previously the settings directory) now supports tree walking. You can now organize your templates in folders.
---
* The input setting has been reworked to use `InputEvent` resources instead of clunky strings.
* The input setting now supports multiple inputs of the same type for each action (i. e. you can have more than one keyboard or gamepad event for an action).

### Components
* All list components now support using item IDs instead of indices.
* The input button now supports icons for mouse events.
* UI components now warn the user when they don't have a setting or their setting is invalid.
* You can now set up sound effects for UI components.


# Previous Versions

<details>
<summary>3.0 Changelog</summary>

## 3.0.3
* Fixed category selection bug in Godot 4.1

## 3.0.2
* Fixed an issue where the game would crash if the user attempted to rebind input using mice with more than five keys.
* Fixed an issue where rebinding left and right arrow keys would rebind to the gamepad left button and right button instead.

## 3.0.1
* Centering the window (part of the fullscreen toggle process) now works properly on setups with multiple displays.

## 3.0.0
GGS has been completely reworked so it can provide a much better experience for the users. The new version is compatible with Godot 4 only.

### General
* GGS is now a bottom panel plugin instead of a main screen one.
* The entire UI has been redesigned to make it easier and more intuitive to work with.
* Save data is handled via config files instead of JSON files.
* The way settings are created and handled has been completely reworked.
* The way UI components are added and handled has been completely reworked.

### Settings
* Users should now have more freedom and flexibility when creating custom settings.
* Keyboard Input and Gamepad Input settings have been merged into a single setting. The setting functionality has been improved.

### UI Components
* Users can now create their own custom UI components.
* Keyboard Input and Gamepad Input components have been merged into a single component. The component functionality has been improved.
* New UI components have been added: Apply Button, Radio List, Toggle Button, CheckBox

  
</details>
