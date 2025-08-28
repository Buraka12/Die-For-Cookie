extends Sprite2D

@onready var player: CharacterBody2D = $"../Player"


#butona basma
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		$".".frame = 1

#butondan ayrılma
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		$".".frame = 0
