extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")
const ROCK_PROJECTILE = preload("res://Skills/Dude/RockProjectile.tscn") # normal attack
const DASH_SKILL = preload("res://Skills/Owlet/Dash_Skill.tscn") #skill 1
const DASH_SMOKE = preload("res://Skills/Owlet/DashSmoke.tscn") #skill 1
const WIND_CUTTER = preload("res://Skills/Owlet/WindCutter.tscn") #skill 2
const SCREEN_SHAKER = preload("res://UI/ScreenShake.tscn")
const EXPLOSION = preload("res://Skills/Dude/Explosion.tscn") #Explosion skill
const SPIKEBALL = preload("res://Skills/Dude/SpikeBall.tscn") #Spikeball skill

var CD_health_potion = false
var CD_normal = false
var CD_1 = false
var CD_2 = false
var CD_3 = false

export(int) var max_health = 80
var health = max_health
var isDead = false
export(int) var WALKSPEED = 300
export(int) var JUMPFORCE = 500
export(int) var GRAVITY = 1400
var mouse_pos
var coin = 0

var isFinish = false

onready var FSM = get_node("Dude_FSM")

var FRICTION = 0.5
var velocity = Vector2.ZERO

var normal_color = Color(1, 1, 1)
var transform_color = Color(1, 0.5, 0)
var player_transform_color = Color(0.91, 0.56, 0.41)
var effect_color = normal_color
var buff_damage = 0
var walk_dir
var normal_range = 5
var improve_skill = 0

func drink_health_potion():
	if Input.is_action_just_pressed("health_potion") and Global.Health_potion_amount != 0 and !CD_health_potion:
		CD_health_potion = true
		$health_potion_cd.start()
		if max_health - 20 >= health:
			health += 20
		elif health + 20 >= max_health:
			health += max_health - health
		$CanvasLayer/HealthBar_player._on_health_updated(health)
		$CanvasLayer/HealthBar_player._on_potion_amount_updated()
		Global.Health_potion_amount -= 1

func get_input_direction():
	if !isFinish:
		walk_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.x = walk_dir * WALKSPEED
	
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y = - JUMPFORCE
	
		if mouse_pos.x < 640:
			$AnimatedSprite.flip_h = true # flip character
		
		if mouse_pos.x > 640:
			$AnimatedSprite.flip_h = false # flip character

func walk_logic():
	if mouse_pos.x < 640 and walk_dir == 1:
		WALKSPEED = 150
	elif mouse_pos.x > 640 and walk_dir == -1:
		WALKSPEED = 150
	else:
		WALKSPEED = 300

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
	self.remove_from_group("player")
	velocity = Vector2.ZERO
	$CanvasLayer/HealthBar_player._on_health_updated(health)
	$CanvasLayer/LoseMenu.visible = true

func decrease_health(damage, enemy_direction):
	health -= damage
	spawn_damageIndicator(damage)
	screen_shaker()
	knockback(enemy_direction)
	$CanvasLayer/HealthBar_player._on_health_updated(health)
	FSM.set_state(FSM.states.hurt)
	if health <= 0:
		dead()
		
# attack
func attack():
	if Input.is_action_just_pressed("left_click"):
		FSM.set_state(FSM.states.attack_1)

func attack_and_run():
	if Input.is_action_just_pressed("left_click"):
		FSM.set_state(FSM.states.attack_run)

func current_state_label():
	$currentState.text = $AnimationPlayer.current_animation
	
func _physics_process(_delta):
	velocity.y += _delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	current_state_label()
	mouse_pos = get_viewport().get_mouse_position()

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

func random_thing_in_array(arr):
	var randomResult = randi()%len(arr)
	return arr[randomResult]

func most_of_arr(arr):
	var most_number = 0
	for i in arr:
		if i > most_number:
			most_number = i
	return most_number

var normal_attack_damage = [7, 8, 9]
func do_damage(body, damage_arr):
	body.knockback($AnimatedSprite.flip_h)
	body.spawn_damageIndicator_enemy(random_thing_in_array(damage_arr), most_of_arr(damage_arr), buff_damage)

func useNormal_Attack():
	if Input.is_action_just_pressed("left_click") and !CD_normal:
		FSM.set_state(FSM.states.skill_2)
		normal_attack()
		
		CD_normal = true
		$Normal_attackCD.start()
		
func normal_attack():
	var normal_atk = ROCK_PROJECTILE.instance()
	normal_atk.normal_attack(position, $AnimatedSprite.flip_h, effect_color)
	normal_atk.fall_speed -= improve_skill
	get_tree().current_scene.add_child(normal_atk)

func useExplosion():
	if Input.is_action_just_pressed("skill_1") and !CD_1:
		FSM.set_state(FSM.states.skill_1)
		explosion()
		CD_1 = true
		$Skillcd1.start()
		
func explosion():
	var explosion_skill = EXPLOSION.instance()
	explosion_skill.normal_attack(position, $AnimatedSprite.flip_h, effect_color)
	explosion_skill.fall_speed -= improve_skill
	get_tree().current_scene.add_child(explosion_skill)

func useSpikeball():
	if Input.is_action_just_pressed("skill_2") and !CD_2:
		FSM.set_state(FSM.states.skill_2)
		spikeball()
		
		CD_2 = true
		$Skillcd2.start()
		
func spikeball():
	var spikeball_skill = SPIKEBALL.instance()
	spikeball_skill.normal_attack(position, $AnimatedSprite.flip_h, effect_color)
	spikeball_skill.fall_speed -= improve_skill
	get_tree().current_scene.add_child(spikeball_skill)

func use_Selfimprove():
	if Input.is_action_just_pressed("skill_3") and !CD_3:
		FSM.set_state(FSM.states.skill_3)
		selfimprove()
		
		CD_3 = true
		$Skillcd3.start()

func selfimprove():
	$Timer.start()
	improve_skill = 4

func _on_Timer_timeout():
	improve_skill = 0

func _on_ItemCollecter_area_entered(area):
	if area.is_in_group("coin"):
		coin += 5
		$CanvasLayer/HealthBar_player.coinUpdate(coin)
		$CanvasLayer/PassMenu/VBoxContainer/CoinBox/Amount.text = str(coin)
		$CanvasLayer/LoseMenu/VBoxContainer/CoinBox/Amount.text = str(coin)

# when player exited screen will do something
func _on_VisibilityNotifier2D_screen_exited():
	isDead = true
	health -= health
	$CanvasLayer/HealthBar_player._on_health_updated(health)
	$CanvasLayer/LoseMenu.visible = true

func passStage():
	$CanvasLayer/PassMenu.visible = true
	isFinish = true
	velocity = Vector2.ZERO
	
	Global.money += coin


func _on_Skillcd1_timeout():
	CD_1 = false


func _on_Skillcd2_timeout():
	CD_2 = false

func _on_Skillcd3_timeout():
	CD_3 = false


func _on_Normal_attackCD_timeout():
	CD_normal = false


func _on_health_potion_cd_timeout():
	CD_health_potion = false
