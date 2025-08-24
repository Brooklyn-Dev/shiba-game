extends Node

const NUM_CHANNELS := 8
const BUS := "Master"

var available: Array[AudioStreamPlayer] = []
var queue: Array[Dictionary] = []

func _ready():
	for i in NUM_CHANNELS:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_player_finished.bind(p))
		p.bus = BUS

func _process(delta):
	if not queue.is_empty() and not available.is_empty():
		var player = available.pop_back()
		var dict = queue.pop_front()
		player.stream = dict.stream
		player.volume_db = dict.volume_db
		player.play()

func play(audio_stream: AudioStream, volume_db: float = 0.0):
	queue.append({
		"stream": audio_stream,
		"volume_db": volume_db
	})

func _on_stream_player_finished(stream_player: AudioStreamPlayer):
	available.append(stream_player)
