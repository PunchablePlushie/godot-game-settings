# Godot Game Settings (GGS)
Godot Game Settings allows you to create and manage game settings for your small to medium projects. It takes care of all the fundamental functionalities required to have proper game settings, including predefined logic for common settings (e.g. display, audio, input), UI components, saving/loading data, and applying settings.

View the [documentation](docs/home.md) for information on how to use the plugin.

View the [demo branch](https://github.com/PunchablePlushie/godot-game-settings/tree/demo) for information on how to get the demo.

<p align="center">
	<img src="https://i.postimg.cc/rpKvBkSk/ggs-icon-nobg.png" alt="demo preview">
</p>


## Major Update: v3.1.0
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

<p align="right">
	<a href="https://github.com/PunchablePlushie/godot_ggs/wiki/Changelog">Full Changelog</a><br/>
</p>
