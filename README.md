# Godot Game Settings (GGS)
Godot Game Settings is a tool for people who don't want to spend a lot of time coding game settings. Easy to use and easy to expand to fit your own project.
<p align="center">
  <img src="https://i.imgur.com/aOIyWU5.png?2" alt="demo preview">
</p>

## Introduction
The project is component based. Typical setting _types_ (e.g. option list, slider, check button, etc) are all basic components that can be easily instanced and expanded to fit your needs.<br/>

Check out the [github wiki page](https://github.com/PunchablePlushie/godot_ggs/wiki) for complete instructions on how to use GGS.

## Theme
GGS does not come with its own theme. You can check the [GUI Skinning page](https://docs.godotengine.org/en/stable/tutorials/gui/gui_skinning.html) of the Godot documentation to get started with making and using your own theme.

## Demo
A demo is available inside the project itself. When adding GGS to your own project, I recommend not adding the demo folder as that won't be necessary. If you want to checkout the project, simply create an empty Godot project and add GGS to it, so that you won't have to worry about potentially messing up your own project.

## Changelog
* `v1.1`:
  * Renamed `SettingsManager` to `GameSettings`.
  * Changed how the logic functions are created and handled. It should be easier to maintain and use them now.
  * Decluttered the exported variables of `GameSettings`. Each exported variable is now in it's own logic script. No more messy list of variables in the editor, yay!
  * Added full gamepad support. You can rebind gamepad controls now.
  * When rebinding controls, you cannot use already assigned keys now.
  * Not really important but the icon is updated.

* `1.0`:
  * Published the project for the first time.
