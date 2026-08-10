extends EnemyAction

@export var damage := 4
@export var hits := 2

func _ready() -> void:
	super()
	update_intent()
	
func update_intent() -> void:
	if hits != 1:
		intent.number = str(hits) + "x"
	intent.number += str(damage)

func perform_action() -> void:
	if not enemy or not target:
		return
		
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	damage_effect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	for i in range(hits):
		tween.tween_callback(damage_effect.execute.bind(target_array))
		tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.entity_action_completed.emit()
	)
