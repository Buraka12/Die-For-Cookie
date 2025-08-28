extends StaticBody2D

func _ready():
	add_to_group("mirror")
	rotation_degrees = snap_to_45(rotation_degrees)

func snap_to_45(degrees: float) -> float:
	return round(degrees / 45.0) * 45.0
