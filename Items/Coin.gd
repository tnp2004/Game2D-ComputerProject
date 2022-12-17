extends Node2D

func _on_CoinArea_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
