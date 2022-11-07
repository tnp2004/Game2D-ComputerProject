extends Control

func _ready():
	self.visible = true

func get_player_spawner_pos():
	for i in get_tree().current_scene.get_children():
		if i.name == "player_spawner":
			return i.position

func player_spawn(character):
	character.position = get_player_spawner_pos()
	get_tree().current_scene.add_child(character)
	self.queue_free()

func _on_OwletButton_pressed():
	var character = load("res://Characters/Owlet.tscn").instance()
	player_spawn(character)
	
func _on_PinkButton_pressed():
	var character = load("res://Characters/Pink.tscn").instance()
	player_spawn(character)

func _on_DudeButton_pressed():
	var character = load("res://Characters/Dude.tscn").instance()
	player_spawn(character)
