class_name CardUISimple
extends Control

const BASE_STYLEBOX := preload("uid://kyh4qpgdqb8i")
const HOVER_STYLEBOX := preload("uid://d2cqfomrucg14")

@export var card: Card : set = _set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
	
	
func _on_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card.icon, card.processed_tooltip_text)
	
func _on_mouse_exited() -> void:
	panel.set("theme_override_styles/panel", BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	
