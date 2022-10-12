extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("run")
	_add_state("jump")
	_add_state("dead")
	_add_state("attack_1")
	_add_state("attack_2")
	_add_state("attack_run")
	_add_state("skill_1")
	_add_state("skill_2")
	_add_state("skill_3")

func _ready():
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if !parent.isDead:
		parent.get_input_direction()
		parent.useDash_skill()
		parent.useWindCutter_skill()
		parent.useTransform_skill()
		if parent.velocity.length() == 0:
			parent.attack_combo(_delta)
		else:
			parent.attack_and_run()

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.velocity.x != 0:
					return states.run
				else: 
					return states.idle
			else:
				return states.jump
		
		states.run:
			if parent.velocity.length() == 0:
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
				
		states.jump:
			if parent.is_on_floor():
				return states.idle
				
		states.attack_1:
			if !animation_player.is_playing():
				return states.idle
		states.attack_2:
			if !animation_player.is_playing():
				return states.idle
		states.attack_run:
			if !animation_player.is_playing():
				return states.idle
		states.skill_1:
			if !animation_player.is_playing():
				return states.idle
		states.skill_2:
			if !animation_player.is_playing():
				return states.idle
		states.skill_3:
			if !animation_player.is_playing():
				return states.idle
		
	return - 1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.run:
			animation_player.play("run")
		states.jump:
			animation_player.play("jump")
		states.dead:
			animation_player.play("dead")
		states.attack_1:
			animation_player.play("attack_1")
		states.attack_2:
			animation_player.play("attack_2")
		states.attack_run:
			animation_player.play("attack_run")
		states.skill_1:
			animation_player.play("skill_1")
		states.skill_2:
			animation_player.play("skill_2")
		states.skill_3:
			animation_player.play("skill_3")
