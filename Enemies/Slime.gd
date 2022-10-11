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

# chase player
var isChase = false

func get_player_node():
	for i in get_tree().current_scene.get_children():
		if i.is_in_group("player"):
			return i # player node

func chase_player():
	var to_player = (get_player_node().position - position).normalized()
	velocity.x = to_player.x * SPEED * FRICTION
	velocity = move_and_slide(velocity, Vector2.UP)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
		
func _on_Detectplayer_body_entered(body):
	if body.is_in_group("player"):
		isChase = true

func _on_Detectplayer_body_exited(body):
	if body.is_in_group("player"):
		isChase = false
