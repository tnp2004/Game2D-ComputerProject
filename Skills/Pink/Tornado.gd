extends Node2D

var damage_tornado_skill = [3, 4, 5]

var velocity = Vector2.ZERO
var SPEED = 200
var player_is_flip

func tornado(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		$RayCast2D.cast_to.x = -75
		position = Vector2(player_position.x - 90.0, player_position.y - 30.0)
	else:
		$RayCast2D.cast_to.x = 75
		position = Vector2(player_position.x + 90.0, player_position.y - 30.0)

func _physics_process(delta):
	velocity.x = SPEED * delta * (-1 if player_is_flip else 1) 
	translate(velocity)
	wall_check()

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func wall_check():
	if $RayCast2D.is_colliding():
		var wall = $RayCast2D.get_collider().name
		if wall == "TileMap":
			$AnimationPlayer.play("stop")

func _on_SkillArea_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_tornado_skill)
