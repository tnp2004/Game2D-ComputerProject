extends Node2D

var damage_wind_cutter_skill = [5, 6, 7]

var velocity = Vector2.ZERO
var SPEED = 200
var player_is_flip

func wind_cutter(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		$SkillArea.position = Vector2(-40, 0)
		position = Vector2(player_position.x - 90.0, player_position.y)
	else:
		#$SkillArea.position = Vector2(5, 0)
		position = Vector2(player_position.x + 90.0, player_position.y)

func _physics_process(delta):
	velocity.x = SPEED * delta * (-1 if player_is_flip else 1) 
	translate(velocity)

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_SkillArea_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_wind_cutter_skill)
