extends Node2D

var dash_skill = [4, 5, 6]

func effect(player_position, isFlip):
	$AnimatedSprite.flip_h = isFlip
	if isFlip:
		$SkillArea.position = Vector2(-400, 0)
		position = Vector2(player_position.x + 90.0, position.y - 45)
	else:
		$SkillArea.position = Vector2(5, 0)
		position = Vector2(player_position.x - 90.0, position.y - 45)

func _on_SkillArea_area_entered(area):
	if area.is_in_group("enemy"):
		get_tree().current_scene.get_child(0).do_damage(area, dash_skill)
