extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")
const WATERBALL = preload("res://Skills/Pink/Waterball.tscn") #skill 1
const TORNADO = preload("res://Skills/Pink/Tornado.tscn") #skill 2
const EARTHSPIKE = preload("res://Skills/Pink/EarthSpike.tscn") #skill 3
const SCREEN_SHAKER = preload("res://UI/ScreenShake.tscn")

export(int) var max_health = 200
var health = max_health
var isDead = false
export(int) var WALKSPEED = 300
export(int) var JUMPFORCE = 500
export(int) var GRAVITY = 1400

onready var FSM = get_node("Pink_FSM")

var FRICTION = 0.5
var velocity = Vector2.ZERO

var normal_color = Color(1, 1, 1)
var transform_color = Color(1, 0.5, 0)
var player_transform_color = Color(0.91, 0.56, 0.41)
var effect_color = normal_color
var buff_damage = 0

func get_input_direction():
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * WALKSPEED
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = - JUMPFORCE
	
	if direction < 0:
		$AnimatedSprite.flip_h = true # flip character
		$attackArea.position.x = -42 # set position of attackArea
		
	if direction > 0:
		$AnimatedSprite.flip_h = false # flip character
		$attackArea.position.x = 0 # set position of attackArea

var knockback_force = 3000
var knockup_force = - 400
func knockback(enemy_is_flip):
	var direction = - 1 if enemy_is_flip else 1
	velocity.x = lerp(velocity.x, knockback_force, 0.5) * direction
	velocity.y = lerp(0, knockup_force, 0.6)
	velocity = move_and_slide(velocity, Vector2.UP)

func screen_shaker():
	var shake = SCREEN_SHAKER.instance()
	$Camera2D.add_child(shake)
	shake.start()

# health
func dead():
	isDead = true
	FSM.set_state(FSM.states.dead)

func decrease_health(damage, enemy_direction):
	health -= damage
	spawn_damageIndicator(damage)
	screen_shaker()
	knockback(enemy_direction)
	$HealthBar._on_health_updated(health)
	FSM.set_state(FSM.states.hurt)
	if health <= 0:
		dead()
		
# attack
var attack_stage = 1
var time = 0
func attack_combo(delta):
	time += delta # This is stopwatch
	if Input.is_action_just_pressed("left_click") and attack_stage == 1:
		FSM.set_state(FSM.states.attack_1)
		attack_stage = 2
		
	elif Input.is_action_just_pressed("left_click") and attack_stage == 2:
		FSM.set_state(FSM.states.attack_2)
		attack_stage = 1
	
	if time > 1:
		attack_stage = 1
		time = 0

func attack_and_run():
	if Input.is_action_just_pressed("left_click"):
		FSM.set_state(FSM.states.attack_run)

func current_state_label():
	$currentState.text = $AnimationPlayer.current_animation
	
func _physics_process(_delta):
	velocity.y += _delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	current_state_label()

# damage indicator
func spawn_effect(EFFECT, effect_position = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damageIndicator(damage):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)

func _on_attackArea_body_entered(body):
	if body.is_in_group("enemy"):
		do_damage(body, normal_attack)

func random_thing_in_array(arr):
	var randomResult = randi()%len(arr)
	return arr[randomResult]

func most_of_arr(arr):
	var most_number = 0
	for i in arr:
		if i > most_number:
			most_number = i
	return most_number

var normal_attack = [2, 3, 4, 5]
func do_damage(body, damage_arr):
	body.knockback($AnimatedSprite.flip_h)
	body.spawn_damageIndicator_enemy(random_thing_in_array(damage_arr), most_of_arr(damage_arr), buff_damage)

func useWaterball():
	if Input.is_action_just_pressed("skill_1"):
		FSM.set_state(FSM.states.skill_1)
		WaterBall()
		$WaterballTimer2.start()
		$WaterballTimer3.start()

func WaterBall():
	var skill_1_phate_1 = WATERBALL.instance()
	skill_1_phate_1.waterball(position, $AnimatedSprite.flip_h, effect_color)
	get_tree().current_scene.add_child(skill_1_phate_1)
	
func useTornado_skill():
	if Input.is_action_just_pressed("skill_2"):
		FSM.set_state(FSM.states.skill_2)
		tornado_skill()
		
func tornado_skill():
	var skill_2 = TORNADO.instance()
	skill_2.tornado(position, $AnimatedSprite.flip_h, effect_color)
	get_tree().current_scene.add_child(skill_2)

func useEarthspike_skill():
	if Input.is_action_just_pressed("skill_3") and is_on_floor():
		FSM.set_state(FSM.states.skill_3)
		earthspike_skill()
		
func earthspike_skill():
	var skill_3 = EARTHSPIKE.instance()
	skill_3.Earthspike(position, $AnimatedSprite.flip_h, effect_color)
	get_tree().current_scene.add_child(skill_3)


func _on_WaterballTimer_timeout():
	WaterBall()

func _on_WaterballStopTimer_timeout():
	WaterBall()
