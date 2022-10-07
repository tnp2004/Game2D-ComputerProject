extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("run")
	_add_state("jump")

func _ready():
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	parent.get_input_direction()

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
	return - 1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.run:
			animation_player.play("run")
		states.jump:
			animation_player.play("jump")
