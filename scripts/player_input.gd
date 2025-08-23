extends Node

signal button_pressed(button: String)

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		button_pressed.emit(event.as_text_keycode())
