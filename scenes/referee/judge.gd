extends Node

signal note_judged(judgement: String, score: int, note: Note)

var composer: Node
var music_player: AudioStreamPlayer

# Basic timings for now
const TIMING_WINDOWS: Dictionary[String, float] = {
	"PERFECT": 0.035,  # ±35ms
	"GREAT": 0.070,  # ±70ms
	"GOOD": 0.110, # ±110ms
	"OK": 0.150, # ±150ms
	"MISS": 0.200 # +200ms
}

func setup(composer_ref: Node, music_player_ref: AudioStreamPlayer):
	composer = composer_ref
	music_player = music_player_ref

func _process(_delta: float) -> void:
	var current_time = music_player.get_playback_position()
	
	for i in range(composer.lane_notes.size()):
		var note = composer.get_next_note(i)
		
		if note == null:
			continue
		
		if current_time > note.time + TIMING_WINDOWS.OK:
			composer.consume_note(note)
			note_judged.emit("MISS", 0, null)

func process_input(lane: int):
	var current_time = music_player.get_playback_position()
	var note = composer.get_next_note(lane)
	if note == null:
		return
	
	var time_diff = abs(current_time - note.time)
	if time_diff > TIMING_WINDOWS.MISS:
		return
	if time_diff > TIMING_WINDOWS.OK:
		composer.consume_note(note)
		note_judged.emit("MISS", 0, null)
		return
	
	var judgement = get_timing_judgement(time_diff)
	var score = get_judgement_score(judgement)
	
	composer.consume_note(note)
	note_judged.emit(judgement, score, note)

func get_timing_judgement(time_diff: float) -> String:
	if time_diff <= TIMING_WINDOWS.PERFECT:
		return "PERFECT"
	if time_diff <= TIMING_WINDOWS.GREAT:
		return "GREAT"
	if time_diff <= TIMING_WINDOWS.GOOD:
		return "GOOD"
	if time_diff <= TIMING_WINDOWS.OK:
		return "OK"
	return "MISS"

func get_judgement_score(judgement: String) -> int:
	match judgement:
		"PERFECT": return 500
		"GREAT": return 200
		"GOOD": return 100
		"OK": return 50
		_: return 0
