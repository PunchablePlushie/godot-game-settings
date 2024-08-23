@tool
extends Node

signal preferences_updated(property: StringName, value: Variant)

signal type_selector_requested
signal hint_selector_requested(type: Variant.Type)
signal input_selector_requested

signal type_selector_confirmed(type: Variant.Type)
signal hint_selector_confirmed(hint: PropertyHint)
signal input_selector_confirmed
