extends Control

func _process(delta):
	$amount.text = str(Global.money)

func _on_item_1_pressed():
	if Global.money >= 15:
		Global.money -= 15
		Global.Health_potion_amount += 1

func _on_Backbutton_pressed():
	get_tree().change_scene("res://UI/Mainmenu.tscn")
