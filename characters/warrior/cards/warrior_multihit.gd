extends Card

func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = Functions.execute_instructions(3, instructions[instruction_type])
	damage_effect.sound = sound
	damage_effect.execute(targets)
	await Functions.wait(.2)
	damage_effect.execute(targets)
	await Functions.wait(.2)
	damage_effect.execute(targets)
	Events.card_animation_completed.emit()
