extends Control

# warning-ignore:return_value_discarded
func _on_Start_pressed():
	get_tree().change_scene("res://UI/Mapselecter.tscn")

func _on_Shop_pressed():
	pass # Replace with function body.


func _on_Info_pressed():
	pass # Replace with function body.


func _on_Help_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
