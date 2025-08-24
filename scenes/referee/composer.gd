extends Node

var all_notes: Array[Note] = []
var lane_notes: Array[Array] = [[], [], [], []]

func load_chart(data: Array[Note]):
	all_notes = data.duplicate(true)
	
	for i in range(4):
		lane_notes[i].clear()
	
	for note in data:
		lane_notes[note.lane].append(note)
	
	for lane in lane_notes:
		lane.sort_custom(func(a, b): a.time < b.time)

func get_next_note(lane: int) -> Note:
	if lane < 0 or lane >= lane_notes.size() or lane_notes[lane].is_empty():
		return null
	
	return lane_notes[lane][0]

func consume_note(note: Note):
	if note.lane >= 0 and note.lane < lane_notes.size():
		lane_notes[note.lane].remove_at(0)
	all_notes.erase(note)
