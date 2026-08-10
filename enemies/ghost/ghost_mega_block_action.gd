extends EnemyAction

@export var block := 15
@export var hp_threshold := 0.5
@export var usages := 1

func is_performable() -> bool:
	if not enemy or usages == 0:
		return false
	
	var is_low := enemy.stats.health <= enemy.stats.max_health/2
	usages -= int(is_low)
	if usages == 0:
		enemy.remove_status_effect(StatusEffect.Type.FEARFUL)
	
	return is_low
		
func perform_action() -> void:
	if not enemy or not target:
		return
		
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.sound = sound
	block_effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.entity_action_completed.emit()
	)
