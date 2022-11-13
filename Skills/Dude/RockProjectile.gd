extends KinematicBody2D

var damage_normal_attack = [3, 4, 5]
var velocity = Vector2.ZERO
const SPEED = 500
var GRAVITY = 10
var player_is_flip
var isDown = false
var player_mouse_pos

func _physics_process(delta):
	print("player =>", player_mouse_pos)
	print("rock", global_position)
	velocity.x = SPEED * delta * (-1 if player_is_flip else 1)
	if isDown:
		velocity.y += GRAVITY * delta
		move_and_slide(velocity)
	else:
		rock_attack_pos(delta)

func launch(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		position = Vector2(player_position.x - 90.0, player_position.y)
	else:
		position = Vector2(player_position.x + 90.0, player_position.y)

func rock_attack_pos(delta):
	if !isDown:
		velocity.y += delta * SPEED * -1
		move_and_slide(velocity)
	if global_position.y > -1000:
		isDown = true

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_normal_attack)
