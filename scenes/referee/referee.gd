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

func _ready() -> void:
	judge.setup(composer, music_player)
	note_spawner.setup(composer, music_player)
	
	PlayerInput.button_pressed.connect(_on_button_pressed)
	judge.note_judged.connect(_on_note_judged)
	
	var test_chart: Array[Note] = [
		Note.new(3, 0, "tap"),
		Note.new(4, 3, "tap"),
		Note.new(4, 1, "tap"),
		Note.new(3, 2, "tap"),
		Note.new(5, 2, "tap"),
	]
	composer.load_chart(test_chart)
	
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
