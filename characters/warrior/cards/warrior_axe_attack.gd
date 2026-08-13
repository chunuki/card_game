extends Card

func apply_effects(targets: Array[Node], char_stats: CharacterStats) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = Functions.execute_instructions(number, instructions["damage_modifier"])
	damage_effect.sound = sound
	damage_effect.execute(targets)
	Events.card_animation_completed.emit()
