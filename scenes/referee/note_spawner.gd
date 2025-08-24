extends Node

const BASE_SCROLL_SPEED := 100

@export_range(1, 0, 1) var scroll_speed := 5 
@export var note_scene: PackedScene

@export var lane_spawns: Array[Node2D] = []
@export var judgement_line: Node2D

var composer: Node
var music_player: AudioStreamPlayer

var spawned_notes: Array[Note] = []

func setup(composer_ref: Node, music_player_ref: AudioStreamPlayer):
	composer = composer_ref
	music_player = music_player_ref

func _process(_delta: float) -> void:
	if not music_player.is_playing:
		return
	
	var current_time = music_player.get_playback_position()
	
	for note in composer.all_notes:
		if note in spawned_notes:
			continue
		
		var spawn_time = calculate_spawn_time(note.time)
		if current_time >= spawn_time:
			spawn_note(note)
			spawned_notes.append(note)

func spawn_note(note: Note) -> void:
	var note_instance = note_scene.instantiate()
	lane_spawns[note.lane].add_child(note_instance)
	note_instance.position = Vector2.ZERO
	note_instance.setup(music_player, judgement_line.position.y, BASE_SCROLL_SPEED * scroll_speed, note)

func calculate_spawn_time(note_hit_time: float) -> float:
	var distance = (judgement_line.global_position.y - lane_spawns[0].global_position.y)
	var fall_time = distance / (BASE_SCROLL_SPEED * scroll_speed)
	return (note_hit_time - fall_time)
