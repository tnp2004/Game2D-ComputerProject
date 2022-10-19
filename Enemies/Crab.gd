extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")
onready var FSM = get_node("Crab_FSM")

export(int) var max_health = 200
var health = max_health
var isDead = false

export(int) var SPEED = 100
var JUMPFORCE = 100
const FRICTION = 0.5
const GRAVITY = 1000
var velocity = Vector2.ZERO
var attack_damage = [2, 3, 4]

var knockback_force = 5000
var knockup_force = - 200
func knockback(player_is_flip):
	var my_direction = - 1 if player_is_flip else 1
	velocity.x = lerp(velocity.x, knockback_force, 0.5) * my_direction
	velocity.y = lerp(0, knockup_force, 0.6)
	velocity = move_and_slide(velocity, Vector2.UP)

# Health
func dead():
	isDead = true
	FSM.set_state(FSM.states.dead)

func decrease_health(damage):
	health -= damage
	FSM.set_state(FSM.states.hurt)
	$HealthBar._on_health_updated(health)
	if health <= 0:
		dead()

# damage indicator
func spawn_effect(EFFECT, effect_position = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damageIndicator_enemy(damage, most_damage, buff_damage):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	var total_damage = damage + buff_damage
	decrease_health(total_damage)
	if indicator:
		if damage == most_damage:
			indicator.label.add_color_override("font_color", Color(1, 0, 0))
		indicator.label.text = str(total_damage)

# enemy intelligent
var isChase = false
var direction = 1
var is_turn_around_cooldown = false

func hide_attack_effect():
	if $AnimationPlayer.current_animation != "attack":
		$effect.visible = false

func get_player_node():
	for i in get_tree().current_scene.get_children():
		if i.is_in_group("player"):
			return i # player node

# attacking
func random_thing_in_array(arr):
	var randomResult = randi()%len(arr)
	return arr[randomResult]

func attacking(body):
	FSM.set_state(FSM.states.attack)
	body.decrease_health(random_thing_in_array(attack_damage), $AnimatedSprite.flip_h)

func _on_AttackArea_body_entered(body):
	if body.is_in_group("player"):
		if !body.isDead:
			attacking(body)

func isFlip():
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$Grounddetecter.position.x = - 36
		$Walldetecter.cast_to.x = - 50
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$Grounddetecter.position.x = 36
		$Walldetecter.cast_to.x = 50
	$effect.flip_h = $AnimatedSprite.flip_h

func chase_player():
	var to_player = (get_player_node().position - position).normalized()
	velocity.x = to_player.x * SPEED * FRICTION
	velocity = move_and_slide(velocity, Vector2.UP)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
func walk_around():
	if !isChase:
		velocity.x = SPEED * FRICTION * direction
		velocity = move_and_slide(velocity, Vector2.UP)

func turn_around():
	if $Walldetecter.is_colliding() and !is_turn_around_cooldown or !$Grounddetecter.is_colliding():
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

func _on_AttackArea_body_exited(body):
	pass
