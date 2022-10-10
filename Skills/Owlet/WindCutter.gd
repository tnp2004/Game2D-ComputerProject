extends Node2D

var damage_wind_cutter_skill = [5, 6, 7]

var velocity = Vector2.ZERO
var SPEED = 200
var player_is_flip

func wind_cutter(player_position, isFlip):
	player_is_flip = isFlip
	$AnimatedSprite.flip_h = isFlip
	if isFlip:
		$SkillArea.position = Vector2(-40, 0)
		position = Vector2(player_position.x - 90.0, player_position.y)
	else:
		#$SkillArea.position = Vector2(5, 0)
		position = Vector2(player_position.x + 90.0, player_position.y)

func _physics_process(delta):
	velocity.x = SPEED * delta * (-1 if player_is_flip else 1) 
	translate(velocity)


func _on_SkillArea_area_entered(area):
	if area.is_in_group("enemy"):
		get_tree().current_scene.get_child(0).do_damage(area, damage_wind_cutter_skill)
