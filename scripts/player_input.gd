extends Node

signal button_pressed(button: String)

const KONAMI_CODE := ["Up", "Up", "Down", "Down", "Left", "Right", "Left", "Right", "B", "A"]
var input_history: Array[String] = []

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var text_keycode = event.as_text_keycode()
		button_pressed.emit(text_keycode)
		
		if text_keycode == "Escape":
			get_tree().quit()
			return
		
		if text_keycode == "R":
			get_tree().reload_current_scene()
			return
		
		input_history.push_back(text_keycode)
		if input_history.size() > KONAMI_CODE.size():
			input_history.pop_front()
			
		if input_history == KONAMI_CODE:
			get_tree().change_scene_to_file("res://scenes/Secret.tscn")
