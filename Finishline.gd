extends Node2D

func _on_Area2D_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		body.passStage()