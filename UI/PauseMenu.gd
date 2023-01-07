extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = !get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_RestartButton_pressed():
	get_tree().paused = false
	var thisStage =  get_tree().current_scene.name
	get_tree().change_scene("res://Stages/" + thisStage + ".tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://UI/Mainmenu.tscn")
