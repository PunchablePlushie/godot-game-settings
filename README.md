# Godot Game Settings (GGS)

Godot Game Settings allows you to create and manage game settings for small to medium sized projects. It includes predefined logic for common game settings (display, audio, input) in addition to a framework for creating and managing custom settings and user interface components.

View the [documentation](https://zijcht.github.io/godot-game-settings-docs/settings/) for information on how to use the plugin.

<p align="center">
	<img src="https://i.postimg.cc/cCGPB9Kt/ggs-icon.png" alt="GGS icon">
</p>

## Changelog

**3.3.0** is a small update primarily ensuring compatibility with Godot 4.5. It also comes with small feature revisions.

### 3.3.0

- Updated for Godot 4.5.
- Improved how the glyph database entries are exported.
- Added a text database resource which allows customizing the text data used for converting mouse and joypad input events into text.
- The name and extension of the save file can no longer be changed.
- Type, hint, and hint string of a setting value can no longer be changed from the editor and should be set in its script instead.
- Removed the ability to use IDs instead of indices from all list components.
- Added the option to disable selection wrapping for arrow lists.
- Added global settings for `apply_on_changed` and `grab_focus_on_mouseover` component properties. Individual component instances can override this if needed.
- Plugin settings is now a resource saved on disc instead of being part of the main singleton.
- Moved setting scripts and components outside of the plugin directory to allow users to use them from the "Quick Load" window without having to toggle the "Addons" filtering option.
- Added a vsync toggle setting.
- Added a max FPS setting.
- Changed display fullscreen setting to allow changing between borderless and exclusive fullscreen modes. The setting is renamed to "display mode".
- Other general codebase improvements.
