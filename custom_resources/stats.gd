class_name Stats
extends Resource

signal stats_changed

@export var max_health := 1
@export var art: Texture
@export var initial_status_effects: Array[StatusEffect] = []


var health: int: set = set_health
var block: int: set = set_block
var status_effects: Array[StatusEffect]


func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func set_block(value : int) -> void:
	block = clampi(value, 0, 999)
	stats_changed.emit()
	
func add_status_effect(current_effect: StatusEffect, count: int) -> void:
	for effect in status_effects:
		if effect.type == current_effect.type:
			effect.count += count
			stats_changed.emit()
			return
	var new_effect = current_effect.duplicate()
	new_effect.count = count
	status_effects.append(new_effect)
	stats_changed.emit()
	
func remove_status_effect(type: StatusEffect.Type) -> void:
	for effect in status_effects:
		if effect.type == type:
			status_effects.erase(effect)
			stats_changed.emit()
			return
	
func get_status_effect(type: StatusEffect.Type) -> StatusEffect:
	for effect in status_effects:
		if effect.type == type:
			return effect
	return null
	
func update_status_effects() -> void:
	for effect in status_effects:
		if effect.tickdown:
			effect.count -= 1
			if effect.count == 0:
				remove_status_effect(effect.type)
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	self.block = clampi(block - initial_damage, 0, block)
	self.health -= damage
	
func heal(amount: int) -> void:
	self.health += amount
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.initial_status_effects = []
	for status_effect : StatusEffect in initial_status_effects:
		if status_effect != null:
			var effect_copy = status_effect.duplicate()
			instance.initial_status_effects.append(effect_copy)
	return instance
