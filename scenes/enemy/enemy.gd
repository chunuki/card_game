class_name Enemy
extends Area2D

const ARROW_OFFSET := 60
const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: EnemyStats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var intent_ui: IntentUI = $IntentUI as IntentUI

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction : set = set_current_action
var damage_instructions: Array[Callable]
var instructions: Dictionary = {
	"damage_modifier" : [],
	"block_modifier" : [],
	"damage_taken_modifier" : []
}


func set_current_action(value: EnemyAction) -> void:
	current_action = value
	if current_action:
		current_action.update_calculations(instructions)
		intent_ui.update_intent(current_action.intent)


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
		
	update_enemy()
	
	
func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self
	
func update_enemy() -> void:
	if not stats is EnemyStats:
		return
	if not is_inside_tree():
		await ready
		
	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	setup_ai()
	update_stats()

func update_tickdowns() -> void:
	stats.update_status_effects()

func update_stats() -> void:
	stats_ui.update_stats(stats)
	
func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
		
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action
	
func do_turn() -> void:
	stats.block = 0
	
	if not current_action:
		return
	
	current_action.perform_action()
	
func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	sprite_2d.material = WHITE_SPRITE_MATERIAL
	
	damage = Functions.execute_instructions(damage, Functions.damage_taken_modifier(stats.status_effects))
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite_2d.material = null
			if stats.health <= 0:
				queue_free()
	)
	
func add_status_effect(current_effect: StatusEffect, count: int) -> void:
	stats.add_status_effect(current_effect, count)
	match current_effect.type:
		StatusEffect.Type.STRENGTH:
			instructions["damage_modifier"] = Functions.damage_modifier(stats.status_effects)
		StatusEffect.Type.DEXTERITY:
			instructions["block_modifier"] = Functions.block_modifier(stats.status_effects)

func remove_status_effect(type: StatusEffect.Type) -> void:
	stats.remove_status_effect(type)

func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()
