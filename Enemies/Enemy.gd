extends Node2D

func _ready():
	pass

func _on_Area2D_body_entered(body):
	print(body.is_in_group("player"))
