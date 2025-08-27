extends Node

@export var shiba_bark_sfx: AudioStream
@export var shiba_hitbox: Panel
@export var woof_label: Label

func _ready() -> void:
	shiba_hitbox.self_modulate.a = 0.0
	woof_label.text = ""
	
	shiba_hitbox.gui_input.connect(_on_shiba_hitbox_input)

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_shiba_hitbox_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		woof_label.text += " Woof!"
		SfxManager.play(shiba_bark_sfx)
