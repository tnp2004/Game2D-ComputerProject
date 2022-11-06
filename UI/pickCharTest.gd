extends Control

onready var SCENE = preload("res://Stages/World.tscn")
onready var owlet_character = preload("res://Characters/Owlet.tscn").instance()

onready var player_position = preload("res://Stages/World.tscn").instance().get_node("player_spawner").position


func _on_OwletButton_pressed():
	owlet_character.position += player_position
	SCENE.instance().add_child(owlet_character)
	get_tree().change_scene_to(SCENE)
	print("=> ", get_tree().root.get_children())
	
func _on_PinkButton_pressed():
	pass # Replace with function body.

func _on_DudeButton_pressed():
	pass # Replace with function body.
