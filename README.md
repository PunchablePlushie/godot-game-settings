# Godot Game Settings (GGS)
Godot Game Settings is a tool that can help you easily and quickly create and maintain in-game settings menus. Check out the [How to Use page](https://github.com/PunchablePlushie/godot_ggs/wiki/How-to_use) to get started with GGS.
<p align="center">
  <img src="https://i.imgur.com/aOIyWU5.png?2" alt="demo preview">
</p>



## Theme
GGS does not come with themes. You can check the [GUI Skinning page](https://docs.godotengine.org/en/stable/tutorials/gui/gui_skinning.html) of the Godot documentation to get started with making and using your own themes.

## Demo
A demo repo is available that contains two versions of the same project. The "Base" version is the unfinished version that you can use to follow along when reading the [How to Use page](https://github.com/PunchablePlushie/godot_ggs/wiki/How-to_use). If you're looking to just see what a completed project with GGS would look like, you can check out the "Finished" version.

You can find the demo [here.](https://github.com/PunchablePlushie/GGS-Demo)

___

## Changelog
View the [full changelog](https://github.com/PunchablePlushie/godot_ggs/wiki/Changelog).

### Latest Update (v2.3.0)
Thanks to [kingoftheconnors](https://github.com/kingoftheconnors) efforts:
* GGS now supports analog stick inputs. So `ggsKeybindGp` components can now detect analog stick inputs (`InputJoypadMotion`) from the player.

### Latest Major Update (v2.0.0)
GGS has been completely reworked for the `v2.0` version. Instead of relying mostly on nodes themselves, GGS now optimizes plugin features of Godot to create an easier and more intuitive way to create and manage both settings and UI components.
* The way the user interacts with the plugin has been improved:
  * `GameSettings.tscn` is no more. The main manager is now called `ggsManager.gd`. Unlike the previous versions, users don't have to edit the core plugin code itself anymore to use GGS to it's full potential.
  * The plugin now adds a main screen editor to the Godot editor. Everything related to the plugin can be accessed through this new editor.
  * The settings are created and handled differently now. They're no longer node depedant, rather they're just entries in a dictionary. This makes it much easier to edit and maintain the settings list.

* The UI components have been reworked:
  * The Arrow List component uses texture for its arrows instead of text now.
  * The Keybind components (both keyboard and gamepad) now support glyph icons, in addition to just plain text. 
  * Components are no longer divided into "base" and "generic" groups.
  * Components can now be added to the scene through the main GGS editor. No more trying to find the component you want to instance in the Godot editor.
  * All components have a cleaner scene tree now. This makes modifying them through the Inspector much easier and adds more flexibility when designing the menu UI.
  * Three new components have been added: Text Field, Number Field, and Reset Button.

* Save data is handled differently now. Instead of using ConfigFile, GGS uses JSON files and dictionaries to save and load data.
* The way logic scripts are created and handled is slightly different now.
* Choosing a default value for each setting is done through the GGS editor and by using dictionaries, instead of the previous method of providing a default config file.
* The game settings should work properly after exporting the game now. The previous version had some issues with exporting.
___
