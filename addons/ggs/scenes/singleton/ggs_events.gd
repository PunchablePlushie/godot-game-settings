@tool
extends Node
## Hosts global events of the GGS plugin.

signal type_selector_requested
signal hint_selector_requested
signal input_selector_requested

signal type_selector_confirmed(type: Variant.Type)
signal hint_selector_confirmed
signal input_selector_confirmed
