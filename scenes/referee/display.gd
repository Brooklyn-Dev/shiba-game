extends CanvasLayer

@onready var score_label := $ScoreRect/ScoreLabel
@onready var combo_label := $TopRect/ComboLabel
@onready var judgement_label := $TopRect/JudgementLabel

func _ready():
	var referee = get_parent()
	referee.connect("score_updated", _on_score_updated)
	referee.connect("combo_updated", _on_combo_updated)
	referee.connect("judgement_made", _on_judgment_made)
	
	score_label.text = "0"
	combo_label.text = "0"
	judgement_label.text = ""

func _on_score_updated(score: int):
	score_label.text = str(score)

func _on_combo_updated(combo: int):
	combo_label.text = str(combo)

func _on_judgment_made(judgement: String, colour: Color = Color.WHITE):
	judgement_label.text = judgement
	judgement_label.add_theme_color_override("font_color", colour)
