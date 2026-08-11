class_name Player
extends Node2D

const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

var instructions: Dictionary = {
	"damage_modifier" : [],
	"block_modifier" : [],
	"damage_taken_modifier" : []
}

const CARD = 0
const TARGET = 1
var queued_actions := []
var queued_actions_index := 0

func _ready() -> void:
	Events.card_queued.connect(_on_card_queued)
	Events.card_animation_completed.connect(_on_card_animation_completed)
	
func _on_card_queued(card: Card, targets: Array) -> void:
	stats.mana -= card.cost
	queued_actions.append([card, targets])

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		
	update_player()
	
func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
		
	sprite_2d.texture = stats.art
	update_stats()
	
func update_stats() -> void:
	stats_ui.update_stats(stats)
	
func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
		
	sprite_2d.material = WHITE_SPRITE_MATERIAL
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite_2d.material = null
			if stats.health <= 0:
				Events.player_died.emit()
				queue_free()
	)

func add_status_effect(current_effect: StatusEffect, count: int) -> void:
	stats.add_status_effect(current_effect, count)
	match current_effect.type:
		StatusEffect.Type.STRENGTH:
			instructions["damage_modifier"] = Functions.damage_modifier(stats.status_effects)
		StatusEffect.Type.DEXTERITY:
			instructions["block_modifier"] = Functions.block_modifier(stats.status_effects)
	Events.instructions_requested.emit(instructions)

func do_turn() -> void:
	if queued_actions == []:
		Events.entity_action_completed.emit()
		return
	var first_action = queued_actions[0]
	first_action[CARD].play(first_action[TARGET], stats)

func _on_card_animation_completed() -> void:
	if queued_actions_index == queued_actions.size()-1:
		queued_actions_index = 0
		queued_actions = []
		Events.entity_action_completed.emit()
		return
	queued_actions_index += 1
	var next_action = queued_actions[queued_actions_index]
	if next_action:
		next_action[CARD].play(next_action[TARGET], stats)
