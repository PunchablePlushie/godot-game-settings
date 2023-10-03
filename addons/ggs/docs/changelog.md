# 3.0.3
* Fixed category selection bug in Godot 4.1

# 3.0.2
* Fixed an issue where the game would crash if the user attempted to rebind input using mice with more than five keys.
* Fixed an issue where rebinding left and right arrow keys would rebind to the gamepad left button and right button instead.

# 3.0.1
* Centering the window (part of the fullscreen toggle process) now works properly on setups with multiple displays.

# 3.0.0
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
* Keyboard Input and Gamepad Input components have been merged into a single component. The component functionlity has been improved.
* New UI components have been added: Apply Button, Radio List, Toggle Button, CheckBox
