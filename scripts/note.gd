class_name Note extends RefCounted

@export_range(0.0, 999, 0) var time := 0.0
@export_range(0, 3) var lane := 0
@export_enum("tap", "hold", "choice_inner", "choice_outer") var type := "tap"
@export_range(0.0, 999, 0) var duration := 0.0

func _init(time_: float = 0.0, lane_: int = 0, type_: String = "tap", duration_: float = 0.0) -> void:
	time = time_
	lane = lane_
	type = type_
	duration = duration_
