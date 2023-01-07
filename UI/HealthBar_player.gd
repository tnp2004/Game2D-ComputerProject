extends Control

var max_health = 0
var current_health = 0

func _ready():
	max_health = get_parent().get_parent().max_health
	current_health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = max_health
	$ProgressBar2.max_value = max_health
	$ProgressBar2.value = max_health
	$ProgressBar/Label.text = str(current_health) + "/" + str(max_health)
	set_up_icon_char()

func _process(delta):
	$Name.text = str(Global.player_name)

func set_up_icon_char():
	if get_player_node():
		var character = get_player_node().name
		var char_icon = "res://charactersIcon/" + character + ".png"
		$TextureRect2.texture = load(char_icon)

func _on_health_updated(health):
	$ProgressBar.value = health
	$ProgressBar2.value = health
	current_health = health
	$ProgressBar/Label.text = str(current_health) + "/" + str(max_health)

func get_player_node():
	for i in get_tree().current_scene.get_children():
		if i.is_in_group("player"):
			return i # player node

func coinUpdate(coinTotal):
	$coinCounter.text = str(coinTotal)
