Changes keyboard/mouse or gamepad event of a specific input action (i.e. rebinds an input).

## Properties
* default/current - *String* : Must be an input keyword.
* action - *String* : The name of the target action in the input map.
* type - *int (enum)* : The type of input this setting is for.

## Input Keywords
Input keywords are strings that correspond to a certain input. GGS converts this string into an actual `InputEvent` using the `ggsInputHelper` class. All keywords must be lowercase.

### Keyboard
Keyboard keywords are pretty self-explanatory. For example, `d` corresponds to the **D** key on the keyboard (`KEY_D` in Godot). `escape` corresponds to the **Esc** key on the keyboard (`KEY_ESCAPE` in Godot).

### Mouse
| Button  | Keyword | Wheel | Keyword |
| ------------- | ------------- | ------------- | ------------- |
| Left Click  | lmb | Wheel Up | mw_up |
| Right Click | rmb | Wheel Down | mw_down |
| Middle Click| mmb | Wheel Left | mw_left |
| Misc 1 | mb1 | Wheel Right | mw_right |
| Misc 2 | mb2 |

### Modifiers
Keyboard and mouse inputs can accept modifiers. To add a modifier, write a modifier keyword before the main keyword followed by a comma. Do **not** add a space after the comma.

Examples: `shift,d`, `ctrl,alt,rmb`, `alt,f4`
| Modifier| Keyword |
| ------------- | ------------- |
| Shift  | shift |
| Control  | ctrl |
| Alt  | alt |

### Gamepad
| Button        | Keyword | Button     | Keyword | Button         | Keyword        | Button | Keyword | Button   | Keyword | Button | Keyword |
| ------        | -----   | ------     | ------  | ------         | ------         | ------ | ------  | ------   | ------  | ------ | ------  |
| Bottom Button | bbot     | DPad Right | dright  | Left Stick     | left_stick     | Back   | back    | Paddle 1 | pad1    | Touch  | touch   |
| Right Button  | bright   | DPad Left  | dleft   | Right Stick    | right_stick    | Guide  | guide   | Paddle 2 | pad2    |
| Top Button    | btop     | DPad Up    | dup     | Left Shoulder  | left_shoulder  | Start  | start   | Paddle 3 | pad3    |
| Left Button   | bleft    | DPad Down  | ddown   | Right Shoulder | right_shoulder | Misc   | misc    | Paddle 4 | pad4    |

| Left Stick | Keyword  |  Right Stick | Keyword  | Triggers | Keyword       |
| ------     | ------   | ------       | ------   | ------   | ------        |
| Left       | ls_left  | Left         | rs_left  | Left     | left_trigger  |
| Right      | ls_right | Right        | rs_right | Right    | right_trigger |
| Up         | ls_up    | Up           | rs_up    |
| Down       | ls_down  | Down         | rs_down  |
