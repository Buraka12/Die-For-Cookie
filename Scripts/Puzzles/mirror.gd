extends StaticBody2D

func _ready():
	# Add to mirror group for laser detection
	add_to_group("mirror")
	# Initial 45-degree rotation
