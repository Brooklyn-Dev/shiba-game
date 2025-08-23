extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var composer: Node = $Composer
@onready var judge: Node = $Judge

var is_playing := false
var total_score := 0
var combo := 0

func _ready() -> void:
	judge.setup(composer, music_player)
	
	PlayerInput.button_pressed.connect(_on_button_pressed)
	judge.note_judged.connect(_on_note_judged)
	
	var test_chart: Array[Note] = [
		Note.new(1, 0, "tap"),
		Note.new(2, 1, "tap"),
		Note.new(1, 2, "tap"),
		Note.new(2, 3, "tap"),
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
	print("%s +%d" % [judgement, score])
	total_score += score
	
	if judgement == "MISS":
		combo = 0
	else:
		combo += 1
	
	print("Score: %d | Combo %d" % [total_score, combo])
