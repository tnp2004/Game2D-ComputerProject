extends Control

func _on_NextButton_pressed():
	get_tree().change_scene("res://UI/Mapselecter.tscn")


func _on_RepeatButton_pressed():
	var thisStage =  get_tree().current_scene.name
	get_tree().change_scene("res://Stages/" + thisStage + ".tscn")


func _on_HomeButton_pressed():
	get_tree().change_scene("res://UI/Mainmenu.tscn")
