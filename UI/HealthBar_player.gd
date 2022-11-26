extends Control

func _ready():
	$ProgressBar.max_value = get_parent().max_health
	$ProgressBar.value = get_parent().max_health

func _on_health_updated(health):
	$ProgressBar.value = health
