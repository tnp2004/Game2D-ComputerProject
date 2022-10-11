extends Node2D

func dash_smoke_effect(player_position, isFlip, color):
	isFlip = !isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		position = Vector2(player_position.x + 90.0, player_position.y + 10)
	else:
		position = Vector2(player_position.x - 90.0, player_position.y + 10)
