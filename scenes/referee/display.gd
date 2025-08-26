extends CanvasLayer

@onready var score_label := $ScoreRect/ScoreLabel
@onready var combo_label := $TopRect/ComboLabel
@onready var judgement_label := $TopRect/JudgementLabel

@onready var perfect_label := $JudgementsRect/PerfectRect/QuantityLabel
@onready var great_label := $JudgementsRect/GreatRect/QuantityLabel
@onready var good_label := $JudgementsRect/GoodRect/QuantityLabel
@onready var ok_label := $JudgementsRect/OkRect/QuantityLabel
@onready var missed_label := $JudgementsRect/MissedRect/QuantityLabel

@onready var fps_label := $FPSLabel

func _ready():
	var referee = get_parent()
	referee.connect("score_updated", _on_score_updated)
	referee.connect("combo_updated", _on_combo_updated)
	referee.connect("judgement_made", _on_judgment_made)
	
	score_label.text = "0"
	combo_label.text = "0"
	judgement_label.text = ""
	
	perfect_label.text = "0"
	great_label.text = "0"
	good_label.text = "0"
	ok_label.text = "0"
	missed_label.text = "0"
	
	fps_label.text = "FPS: N/A"

func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_score_updated(score: int):
	score_label.text = str(score)

func _on_combo_updated(combo: int):
	combo_label.text = str(combo)

func _on_judgment_made(judgement: String, colour: Color = Color.WHITE):
	judgement_label.text = judgement
	judgement_label.add_theme_color_override("font_color", colour)
	
	match judgement:
		"PERFECT":
			perfect_label.text = str(int(perfect_label.text) + 1)
		"GREAT":
			great_label.text = str(int(great_label.text) + 1)
		"GOOD":
			good_label.text = str(int(good_label.text) + 1)
		"OK":
			ok_label.text = str(int(ok_label.text) + 1)
		"MISS":
			missed_label.text = str(int(missed_label.text) + 1)
