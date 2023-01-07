extends Control

# warning-ignore:return_value_discarded
func _on_Map1button_pressed():
	get_tree().change_scene("res://Stages/Stage_1.tscn")

func _on_Map2button_pressed():
	get_tree().change_scene("res://Stages/Stage_2.tscn")

func _on_Map3button_pressed():
	pass # Replace with function body.

# warning-ignore:return_value_discarded
func _on_Backbutton_pressed():
	get_tree().change_scene("res://UI/Mainmenu.tscn")
