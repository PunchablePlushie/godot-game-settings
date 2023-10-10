It's a required component for [Input Button](input_button.md) to work properly. Must be instantiated in the scene tree directly. One instance is enough.

## Properties
* listening_wait_time - *float* : When listening for input, the time it takes for the received input to be confirmed.
* listening_max_time - *float* : When listening for input, the maximum time the window will listen for input before it stops.
* show_progress_bar - *bool* : Whether to show the progress bar under the listen for input button when listening for input.
* btn_listening - *String* : Text displayed on the listen for input button when the window is listening for input.
* title_listening - *String* : Window title when it's listening for input.
* title_confirme - *String* : Window title when it's not listening for input.
* timeout_text - *String* : Text displayed on the listen for input button when the listening times out.
* already_exists_msg - *String* : Text displayed below the listen for input button when the received input already exists. You can use `{action}` as a placeholder for the action that has the conflicting input event.
