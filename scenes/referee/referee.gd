extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var metronome: Node = $Metronome

var is_playing := false
var score := 0
var combo := 0

func _ready() -> void:
	PlayerInput.button_pressed.connect(_on_button_pressed)
	
	_start_game()

func _start_game() -> void:
	is_playing = true
	score = 0
	combo = 0
	music_player.play()

func _on_button_pressed(button: String) -> void:
	if not is_playing:
		return
	
	var lane := -1
	match button:
		"S": lane = 0
		"D": lane = 1
		"J": lane = 2
		"K": lane = 3
	
	print(lane)
	
	#if lane >= 0:
		# judge do stuff
