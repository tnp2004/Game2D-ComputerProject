extends Node2D

var damage_earth_spike_skill = [3, 4, 5]

var velocity = Vector2.ZERO
var SPEED = 200
var player_is_flip
var isOnfloor = false
const GRAVITY = 500

func Earthspike(player_position, isFlip, color):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	$AnimatedSprite.modulate = color
	if isFlip:
		position = Vector2(player_position.x - 90.0, player_position.y - 30.0)
	else:
		position = Vector2(player_position.x + 90.0, player_position.y - 30.0)

func _physics_process(delta):
	if !isOnfloor:
		velocity.y = delta * GRAVITY
		translate(velocity)

func get_player_node():
	for i in range(len(get_tree().current_scene.get_children())):
		var child = get_tree().current_scene.get_children()[i]
		if child.is_in_group("player"):
			return i # index of player node

func _on_SkillArea_body_entered(body):
	if body.is_in_group("enemy"):
		get_tree().current_scene.get_child(get_player_node()).do_damage(body, damage_earth_spike_skill)

func _on_FloorCheck_body_entered(body):
	if body.name == "TileMap":
		isOnfloor = true
