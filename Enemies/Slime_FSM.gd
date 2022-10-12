extends FiniteStateMachine

func _init():
	_add_state("run")
	_add_state("hurt")
	_add_state("dead")
	_add_state("attack")

func _ready():
	set_state(states.run)

func _state_logic(_delta: float) -> void:
	if !parent.isDead:
		if parent.isChase:
			parent.chase_player()
		parent.turn_around()
		parent.walk_around()
		parent.isFlip()

func _get_transition() -> int:
	match state:
		states.run:
			if !parent.isDead:
				if parent.velocity.x == 0:
					return states.attack
			else:
				return states.dead
				
		states.attack:
			if !animation_player.is_playing():
				return states.run
		
		states.hurt:
			if !animation_player.is_playing():
				return states.run
			
	return - 1

func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.run:
			animation_player.play("run")
		states.hurt:
			animation_player.play("hurt")
		states.attack:
			animation_player.play("attack")
		states.dead:
			animation_player.play("dead")
