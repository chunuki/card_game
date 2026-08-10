class_name StatsUI
extends VBoxContainer

const status_effect_stats_ui_scene : PackedScene = preload("res://scenes/ui/status_effect_stats_ui.tscn")

@onready var block: HBoxContainer = $MainStats/Block
@onready var block_label: Label = %BlockLabel
@onready var health: HBoxContainer = $MainStats/Health
@onready var health_label: Label = %HealthLabel
@onready var status_effects: HBoxContainer = $StatusEffects


func update_stats(stats: Stats) -> void:
	block_label.text = str(stats.block)
	health_label.text = str(stats.health)
	
	for child in status_effects.get_children():
		child.queue_free()
	for status_effect in stats.status_effects:
		if status_effect != null:
			var status_effect_stats_ui : StatusEffectStatsUI = status_effect_stats_ui_scene.instantiate()
			status_effect_stats_ui.setup_information(status_effect)
			status_effects.add_child(status_effect_stats_ui)
	
	block.visible = stats.block > 0
	health.visible = stats.health > 0

func _on_status_effects_mouse_entered() -> void:
	if status_effects.has_meta("active_effect"):
		var effect: StatusEffect = status_effects.get_meta("active_effect")
		var description: String = effect.get_description()
		var icon_label: Texture2D = effect.icon_label
		Events.status_effects_ui_requested.emit(icon_label, description)

func _on_status_effects_mouse_exited() -> void:
	Events.status_effects_ui_hide_requested.emit()
