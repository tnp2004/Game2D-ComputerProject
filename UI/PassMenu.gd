extends Control

func _on_NextButton_pressed():
	get_tree().change_scene("res://UI/Mapselecter.tscn")


func _on_RepeatButton_pressed():
	var thisStage = str(get_tree().get_root().get_child(0).name)
	get_tree().change_scene("res://Stages/" + thisStage + ".tscn")


func _on_HomeButton_pressed():
	get_tree().change_scene("res://UI/Mainmenu.tscn")
