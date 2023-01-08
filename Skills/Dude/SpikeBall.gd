extends Node2D

var damage = [1, 2, 3]

var velocity = Vector2.ZERO
var SPEED = 400
var player_is_flip
var isStop = false
var fall_speed = 5

onready var timestop = $Spintimer.start()

func normal_attack(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		position = Vector2(player_position.x - 90.0, player_position.y)
	else:
		position = Vector2(player_position.x + 90.0, player_position.y)

func _physics_process(delta):
	if !isStop:
		var direction = -1 if player_is_flip else 1
		velocity.x = SPEED * delta * direction
		velocity.y += delta * fall_speed
		if $onGround.is_colliding():
			spin_ahead()
	else:
		velocity = Vector2.ZERO
	
	wall_check()
	translate(velocity)

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage)

func spin_ahead():
	var direction = -1 if player_is_flip else 1
	velocity = Vector2(5 * direction, 0)

func wall_check():
	if $isWall.is_colliding() and $isWall.get_collider().name == "TileMap":
		isStop = true

func _on_Spintimer_timeout():
	$AnimationPlayer.play("destroy")
	isStop = true
