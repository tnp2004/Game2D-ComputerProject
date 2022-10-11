extends FiniteStateMachine

func _init():
	_add_state("run")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")
	_add_state("attack")

func _ready():
	set_state(states.run)

func _state_logic(_delta: float) -> void:
	parent.chase_player()

func _get_transition() -> int:
	match state:
		states.run:
			if parent.velocity.y != 0:
				return states.jump
				
		states.jump:
			if parent.velocity.x != 0:
				return states.run
	return - 1

func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.run:
			animation_player.play("run")
		states.jump:
			animation_player.play("jump")
