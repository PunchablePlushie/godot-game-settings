A confirmation dialog that allows the user to choose an input. Required component for [Input Button](input_button.md) to function. Must be instantiated in the scene tree directly and one instance is enough. You don't have to instantiate it for every Input Button component you have.


# Properties
| Property | Description | Type |
| :---: | --- | :---: |
| listening_wait_time | The time it takes for the input to be accepted when an input is received. | `float` |
| listening_max_time | The maximum time the window will listen for an input before it stops. | `float` |
| show_progress_bar |  Whether to show the bar under the listen button when an input is received. | `bool` |
| btn_listening | Text displayed on the listen button when the window is currently listening for input. | `String` |
| title_listening | Window title when it's currently listening for input. | `String` |
| title_confirm | Window title when it's not listening for input and is awaiting confirmation or cancellation. | `String` |
| timeout_text | Text displayed on the listen button when listening times out. | `String` |
| already_exists_msg | Text displayed below the listen button when the received input already exists. You can use `{action}` as a placeholder for the action that has the conflicting input event | `String` |
