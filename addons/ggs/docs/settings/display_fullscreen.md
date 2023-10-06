Toggles the fullscreen state of the game window.

# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| default/current | The default and current values of the setting. | `bool` |
| size_setting | Name of the setting responsible for resizing the window (e.g. window size, window scale, etc.). If nothing is selected, the window size will not be updated when the fullscreen state is turned off. This is particularly important when the user changes the window size *while* the game is in fullscreen. | `ggsSetting` |
