extends Card

func apply_effects(targets: Array[Node]) -> void:
	status_effect.execute(targets, 1)
	Events.card_animation_completed.emit()
