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
	
func asssign_player_name():
	Global.player_name = str($HBoxContainer2/LineEdit.text)

# warning-ignore:return_value_discarded
func _on_Backbutton_pressed():
	get_tree().change_scene("res://UI/Mapselecter.tscn")

func _on_White_pressed():
	var character = load("res://Characters/Owlet.tscn").instance()
	player_spawn(character)
	asssign_player_name()

func _on_Pink_pressed():
	var character = load("res://Characters/Pink.tscn").instance()
	player_spawn(character)
	asssign_player_name()

func _on_Blue_pressed():
	var character = load("res://Characters/Dude.tscn").instance()
	player_spawn(character)
	asssign_player_name()
