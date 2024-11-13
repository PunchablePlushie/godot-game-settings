# Godot Game Settings (GGS)

Godot Game Settings allows you to create and manage game settings for small to medium projects. It takes care of all the fundamental functionalities required to have proper game settings, including predefined logic for common settings (e.g. display, audio, input), UI components for making scenes, and saving/loading data.

View the [documentation](https://punchableplushie.github.io/godot-game-settings-docs) for information on how to use the plugin.

<p align="center">
	<img src="https://i.postimg.cc/cCGPB9Kt/ggs-icon.png" alt="GGS icon">
</p>

## 3.2.3

- Fix fullscreen setting not having windowed mode.

## 3.2.2

- Fix a type error in the fullscreen setting.
- Change the fullscreen setting to use exclusive fullscreen mode instead.

## 3.2.1

- Fix `EditorInterface` parse error when the project is exported.
- Fix resource loader errors when hte project is exported.

## 3.2.0

This version mainly ported the plugin to Godot 4.3 along adding other small improvements.

- Made compatible with Godot 4.3.
- The plugin no longer features an editor. All operations are done through Godot editor itself.
- Several code improvements, including using doc comments to generate documentation inside the editor.
- Unique icons for components, making them easier to distinguish when making a setting menu.
- Small improvements to the custom property inspectors.
- New icon.
