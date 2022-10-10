extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")
const DASH_SKILL = preload("res://Skills/Owlet/Dash_Skill.tscn") #skill 1
const DASH_SMOKE = preload("res://Skills/Owlet/DashSmoke.tscn") #skill 1
const WIND_CUTTER = preload("res://Skills/Owlet/WindCutter.tscn") #skill 2

export(int) var WALKSPEED = 300
export(int) var JUMPFORCE = 500
export(int) var GRAVITY = 1400

onready var FSM = get_node("Owlet_FSM")

var FRICTION = 0.5
var velocity = Vector2.ZERO

func dash_skill():
	var skill_1 = DASH_SKILL.instance()
	var smoke = DASH_SMOKE.instance()
	skill_1.effect(position, $AnimatedSprite.flip_h)
	smoke.dash_smoke_effect(position, $AnimatedSprite.flip_h)
	print(position)
	position.x += 220 * -1 if $AnimatedSprite.flip_h else 220 * 1
	get_tree().current_scene.add_child(skill_1)
	get_tree().current_scene.add_child(smoke)

func wind_cutter_skill():
	var skill_2 = WIND_CUTTER.instance()
	skill_2.wind_cutter(position, $AnimatedSprite.flip_h)
	get_tree().current_scene.add_child(skill_2)

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

func _on_attackArea_area_entered(area):
	if area.is_in_group("enemy"):
		do_damage(area, normal_attack)

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
func do_damage(area, damage_arr):
	area.get_owner().i_get_attack(random_thing_in_array(damage_arr), most_of_arr(damage_arr))

func useDash_skill():
	if Input.is_action_just_pressed("skill_1"):
		FSM.set_state(FSM.states.skill_1)
		dash_skill()

func useWindCutter_skill():
	if Input.is_action_just_pressed("skill_2"):
		FSM.set_state(FSM.states.skill_2)
		wind_cutter_skill()
