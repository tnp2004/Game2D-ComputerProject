extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")

var SPEED = 200
var JUMPFORCE = 100
const FRICTION = 0.5
const GRAVITY = 1000
var velocity = Vector2.ZERO

func i_get_attack(damage, most_damage, buff_damage):
	spawn_damageIndicator(damage, most_damage, buff_damage)

# damage indicator
func spawn_effect(EFFECT, effect_position = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damageIndicator(damage, most_damage, buff_damage):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		if damage == most_damage:
			indicator.label.add_color_override("font_color", Color(1, 0, 0))
			
		indicator.label.text = str(damage + buff_damage)

# enemy intelligent
var isChase = false
var direction = 1
var is_turn_around_cooldown = false

func get_player_node():
	for i in get_tree().current_scene.get_children():
		if i.is_in_group("player"):
			return i # player node

func isFlip():
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$Grounddetecter.position.x = - 36
		$Walldetecter.cast_to.x = - 50
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$Grounddetecter.position.x = 36
		$Walldetecter.cast_to.x = 50

func chase_player():
	var to_player = (get_player_node().position - position).normalized()
	velocity.x = to_player.x * SPEED * FRICTION
	velocity = move_and_slide(velocity, Vector2.UP)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	walk_around()
	isFlip()
	
func walk_around():
	if !isChase:
		velocity.x = SPEED * FRICTION * direction
		velocity = move_and_slide(velocity, Vector2.UP)

func turn_around():
	if $Walldetecter.is_colliding() and !is_turn_around_cooldown or !$Grounddetecter.is_colliding() and !is_turn_around_cooldown:
		is_turn_around_cooldown = true
		$turn_around_timer.start()
		isChase = false
		direction = -direction

func _on_Detectplayer_body_entered(body):
	if body.is_in_group("player"):
		isChase = true

func _on_Detectplayer_body_exited(body):
	if body.is_in_group("player"):
		isChase = false

func _on_turn_around_timer_timeout():
	is_turn_around_cooldown = false
