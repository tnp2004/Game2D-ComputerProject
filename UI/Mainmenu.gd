extends Control

# warning-ignore:return_value_discarded
func _on_Start_pressed():
	get_tree().change_scene("res://UI/Mapselecter.tscn")

func _on_Shop_pressed():
	get_tree().change_scene("res://UI/Shop.tscn")

func _on_Info_pressed():
	get_tree().change_scene("res://UI/Info.tscn")


func _on_Help_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/HelpMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
