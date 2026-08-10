class_name EnemyHandler
extends Node2D

const ENEMY_INSTANCE : PackedScene = preload("res://scenes/enemy/enemy.tscn")


#func _ready() -> void:
	#Events.enemy_action_completed.connect(_on_enemy_action_completed)

func setup(enemy_info: StageEnemyInfo) -> void:
	for i in enemy_info.enemies.size():
		var enemy_instance : Enemy = ENEMY_INSTANCE.instantiate()
		var enemy_stat : EnemyStats = enemy_info.enemies[i]
		var enemy_pos : Vector2 = enemy_info.enemy_positions[i]
		add_child(enemy_instance)
		Events.entity_instantiated.emit(enemy_instance)
		enemy_instance.global_position = Vector2(enemy_pos.x, enemy_pos.y)
		enemy_instance.set_enemy_stats(enemy_stat)
		for initial_effect in enemy_instance.stats.initial_status_effects:
			enemy_instance.add_status_effect(initial_effect, initial_effect.count)

func reset_enemy_actions() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.current_action = null
		enemy.update_action()

func update_enemy_tickdowns() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.update_tickdowns()

#func start_turn() -> void:
	#if get_child_count() == 0:
		#return
	#
	#var first_enemy: Enemy = get_child(0) as Enemy
	#first_enemy.do_turn()
	
#func _on_enemy_action_completed(enemy: Enemy) -> void:
	#if enemy.get_index() == get_child_count() - 1:
		#Events.enemy_turn_ended.emit()
		#return
		#
	#var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy
	#next_enemy.do_turn()
