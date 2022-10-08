extends KinematicBody2D

export(int) var WALKSPEED = 300
export(int) var JUMPFORCE = 500
export(int) var GRAVITY = 1400

onready var FSM = get_node("Owlet_FSM")

var FRICTION = 0.5
var velocity = Vector2.ZERO

func get_input_direction():
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * WALKSPEED
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = - JUMPFORCE
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	
	if direction > 0:
		$AnimatedSprite.flip_h = false

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

func _on_attackArea_area_entered(area):
	if area.is_in_group("enemy"):
		print("player attack")
