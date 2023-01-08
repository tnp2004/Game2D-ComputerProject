extends Node2D

var damage_normal_attack = [5, 6, 7]

var velocity = Vector2.ZERO
var SPEED = 500
var player_is_flip
var isStop = false

func normal_attack(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		$isCollide.cast_to.x = -75
		position = Vector2(player_position.x - 90.0, player_position.y)
	else:
		$isCollide.cast_to.x = 75
		position = Vector2(player_position.x + 90.0, player_position.y)

func _physics_process(delta):
	if !isStop:
		velocity.x = SPEED * delta * (-1 if player_is_flip else 1) 
	else:
		velocity = Vector2.ZERO
	translate(velocity)

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_SkillArea_body_entered(body):
	$AnimationPlayer.play("collide")
	isStop = true
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_normal_attack)
