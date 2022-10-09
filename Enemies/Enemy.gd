extends KinematicBody2D

const INDICATOR_DAMAGE = preload("res://UI/DamageIndicator.tscn")

func i_get_attack(damage):
	print("ahhh!")
	spawn_damageIndicator(damage)

func _on_Area2D_body_entered(body):
	print(body.is_in_group("player"))

# damage indicator
func spawn_effect(EFFECT, effect_position = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damageIndicator(damage):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)
		if damage == 5:
			indicator.label.add_color_override("font_color", Color(1, 0, 0))
