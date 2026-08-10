extends Card

func apply_effects(targets: Array[Node]) -> void:
	status_effect.count = 1
	status_effect.execute(targets)
	Events.card_animation_completed.emit()
