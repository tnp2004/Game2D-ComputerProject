extends KinematicBody2D

export(int) var WALKSPEED = 100
export(int) var JUMPFORCE = 500
export(int) var GRAVITY = 1000

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

func _physics_process(_delta):
	velocity.y += _delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	print(velocity)
