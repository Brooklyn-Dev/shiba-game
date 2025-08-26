extends Node2D

@onready var tap_visuals: Node2D = $TapVisuals
@onready var hold_visuals: Node2D = $HoldVisuals
@onready var choice_visuals: Node2D = $ChoiceVisuals

var music_player: AudioStreamPlayer

var judgement_line_y: float
var spawn_time: float
var initial_y: float
var fall_speed: float

var smooth_position: float
var lerp_speed := 20.0

func setup(music_player_ref: AudioStreamPlayer, line_y: float, speed: float, note: Note) -> void:
	music_player = music_player_ref
	judgement_line_y = line_y
	fall_speed = speed
	
	spawn_time = music_player.get_playback_position()
	initial_y = position.y
	
	tap_visuals.hide()
	hold_visuals.hide()
	choice_visuals.hide()
	
	match note.type:
		"tap":
			_set_tap_visuals(note)
		"hold":
			_set_hold_visuals(note)
		"choice":
			_set_choice_visuals(note)

func _set_tap_visuals(note: Note):
	tap_visuals.show()
	if note.lane == 0 or note.lane == 3:
		tap_visuals.get_node("InnerTap").hide()
		tap_visuals.get_node("OuterTap").show()
	else:
		tap_visuals.get_node("InnerTap").show()
		tap_visuals.get_node("OuterTap").hide()

func _set_hold_visuals(note: Note):
	#hold_visuals.show()
	assert(0 == 1, "_set_hold_visuals is not implemented")

func _set_choice_visuals(note: Note):
	#choice_visuals.show()
	assert(0 == 1, "_set_choice_visuals is not implemented")

func _process(delta: float) -> void:
	var current_time = music_player.get_playback_position()
	var elapsed = current_time - spawn_time
	smooth_position = initial_y + elapsed * fall_speed
	
	position.y = lerp(position.y, smooth_position, lerp_speed * delta)
	
	if position.y > 800:
		queue_free()
