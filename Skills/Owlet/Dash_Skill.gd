extends Node2D

var damage_dash_skill = [4, 5, 6]

func effect(player_position, isFlip, color):
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		$SkillArea.position = Vector2(-400, 0)
		position = Vector2(player_position.x + 90.0, player_position.y - 15)
	else:
		$SkillArea.position = Vector2(5, 0)
		position = Vector2(player_position.x - 90.0, player_position.y - 15)

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_SkillArea_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_dash_skill)
