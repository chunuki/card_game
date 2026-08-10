extends EnemyAction

@export var effect : StatusEffect
@export var count := 1


func perform_action() -> void:
	if not enemy or not target:
		return
		
	effect.count = 1
	enemy.add_status_effect(effect, count)
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.entity_action_completed.emit()
	)
