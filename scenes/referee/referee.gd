extends Node

signal score_updated(new_score: int)
signal combo_updated(new_combo: int)
signal judgement_made(judgement: String)

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var composer: Node = $Composer
@onready var judge: Node = $Judge
@onready var display: CanvasLayer = $Display
@onready var note_spawner: Node = $NoteSpawner

@export var note_sfx: AudioStream

var is_playing := false
var total_score := 0
var combo := 0

var is_recording := false

func _ready() -> void:
	judge.setup(composer, music_player)
	note_spawner.setup(composer, music_player)
	
	PlayerInput.button_pressed.connect(_on_button_pressed)
	judge.note_judged.connect(_on_note_judged)
	
	var chart: Array[Note] = [
		Note.new(3.391, 3, "tap"),
		Note.new(3.826, 3, "tap"),
		Note.new(4.261, 3, "tap"),
		Note.new(5.122, 0, "tap"),
		Note.new(5.558, 0, "tap"),
		Note.new(5.990, 0, "tap"),
		Note.new(6.826, 3, "tap"),
		Note.new(7.261, 3, "tap"),
		Note.new(7.696, 3, "tap"),
		Note.new(8.609, 0, "tap"),
		Note.new(8.913, 0, "tap"),
		Note.new(9.022, 1, "tap"),
		Note.new(9.130, 2, "tap"),
		Note.new(9.239, 3, "tap"),
		Note.new(9.783, 3, "tap"),
		Note.new(10.217, 3, "tap"),
		Note.new(10.652, 0, "tap"),
		Note.new(12.460, 0, "tap"),
		Note.new(12.887, 0, "tap"),
		Note.new(13.281, 0, "tap"),
		Note.new(13.391, 1, "tap"),
		Note.new(13.537, 2, "tap"),
		Note.new(13.696, 3, "tap"),
		Note.new(14.174, 3, "tap"),
		Note.new(14.652, 3, "tap"),
		Note.new(15.116, 3, "tap"),
		Note.new(15.586, 0, "tap"),
		Note.new(15.637, 2, "tap"),
		Note.new(15.981, 0, "tap"),
		Note.new(16.001, 2, "tap"),
		Note.new(16.435, 3, "tap"), 
		Note.new(16.435, 1, "tap"),
		Note.new(16.870, 1, "tap"),
		Note.new(16.870, 3, "tap"),
		Note.new(17.304, 2, "tap"),
		Note.new(17.304, 0, "tap"),
		Note.new(17.739, 0, "tap"),
		Note.new(17.739, 2, "tap"),
		Note.new(18.174, 3, "tap"),
		Note.new(18.174, 1, "tap"),
		Note.new(18.609, 0, "tap"),
		Note.new(18.609, 2, "tap"),
		Note.new(19.043, 1, "tap"),
		Note.new(19.043, 3, "tap"),
		Note.new(19.478, 1, "tap"),
		Note.new(19.478, 3, "tap"),
		Note.new(19.913, 3, "tap"),
		Note.new(19.913, 1, "tap"),
		Note.new(20.261, 2, "tap"),
		Note.new(20.261, 0, "tap"),
		Note.new(20.783, 0, "tap"),
		Note.new(20.783, 2, "tap"),
		Note.new(21.217, 0, "tap"),
		Note.new(21.217, 2, "tap"),
		Note.new(21.652, 3, "tap"),
		Note.new(21.652, 1, "tap"),
		Note.new(22.087, 1, "tap"),
		Note.new(22.087, 3, "tap"),
		Note.new(22.522, 2, "tap"),
		Note.new(22.522, 0, "tap"),
		Note.new(22.870, 0, "tap"),
		Note.new(22.870, 2, "tap"),
		Note.new(23.435, 3, "tap"),
		Note.new(23.435, 1, "tap"),
		Note.new(23.739, 1, "tap"),
		Note.new(23.739, 3, "tap"),
		Note.new(24.261, 0, "tap"),
		Note.new(24.261, 2, "tap"),
		Note.new(24.609, 0, "tap"),
		Note.new(24.609, 2, "tap"),
		Note.new(25.043, 0, "tap"),
		Note.new(25.348, 3, "tap"),
		Note.new(25.478, 0, "tap"),
		Note.new(25.565, 3, "tap"),
		Note.new(25.652, 0, "tap"),
		Note.new(26.087, 1, "tap"),
		Note.new(26.087, 2, "tap"),
		Note.new(26.348, 1, "tap"),
		Note.new(26.348, 2, "tap"),
		Note.new(26.870, 0, "tap"),
		Note.new(26.870, 3, "tap"),
		Note.new(27.217, 0, "tap"),
		Note.new(27.217, 3, "tap"),
		Note.new(27.652, 0, "tap"),
		Note.new(27.913, 1, "tap"),
		Note.new(28.000, 2, "tap"),
		Note.new(28.087, 3, "tap"),
		Note.new(28.609, 3, "tap"),
		Note.new(29.087, 3, "tap"),
		Note.new(29.435, 0, "tap"),
		Note.new(29.652, 0, "tap"),
		Note.new(29.870, 0, "tap"),
	]
	composer.load_chart(chart)
	
	_start_game()

func _start_game() -> void:
	is_playing = true
	total_score = 0
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
	
	if is_recording:
		var current_time = music_player.get_playback_position()
		print('Note.new(%s, %s, "tap"),' % [current_time, lane])
		return 
	
	if lane >= 0:
		judge.process_input(lane)

func _on_note_judged(judgement: String, score: int, _note: Note) -> void:
	total_score += score
	
	if judgement == "MISS":
		combo = 0
	else:
		combo += 1
		SfxManager.play(note_sfx, 10.0)
	
	score_updated.emit(total_score)
	combo_updated.emit(combo)
	
	var colour = Color.WHITE
	match judgement:
		"PERFECT": colour = Color.CYAN
		"GREAT": colour = Color.GREEN
		"GOOD": colour = Color.YELLOW
		"OK": colour = Color.ORANGE
		"MISS": colour = Color.RED
	judgement_made.emit(judgement, colour)
