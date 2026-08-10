class_name Hand
extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui := preload("res://scenes/card_ui/card_ui.tscn")

var instructions: Dictionary = {
	"damage_modifier" : [],
	"block_modifier" : [],
	"damage_taken_modifier" : []
}

func _ready() -> void:
	Events.instructions_requested.connect(_on_instructions_requested)
	Events.damage_calculation_requested.connect(_on_damage_calculation_requested)
	Events.damage_taken_modification_requested.connect(_on_damage_taken_modification_requested)

func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats

func update_tooltip(card: Card) -> String:
	match card.type:
		Card.Type.ATTACK: card.instruction_type = "damage_modifier"
		Card.Type.SKILL: card.instruction_type = "block_modifier"
		Card.Type.POWER : card.instruction_type = "block_modifier"
		
	if card.instructions.get(card.instruction_type, []) == []:
		if "%d" in card.tooltip_text:
			return card.tooltip_text % Functions.execute_instructions(card.number, instructions["damage_taken_modifier"])
		return card.tooltip_text
	if "%d" in card.tooltip_text:
		var intermediate_damage = Functions.execute_instructions(card.number, card.instructions[card.instruction_type])
		return card.tooltip_text % Functions.execute_instructions(intermediate_damage, instructions["damage_taken_modifier"])
	return card.tooltip_text
	
func discard_card(card: CardUI) -> void:
	card.queue_free()
	
func disable_hand() -> void:
	for card in get_children():
		card.disabled = true

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
	
func _on_instructions_requested(new_instructions: Dictionary) -> void:
	instructions = new_instructions
		
func _on_damage_calculation_requested(cardUI: CardUI) -> void:
	if cardUI in get_children():
		var card : Card = cardUI.card
		card.instructions = instructions
		card.processed_tooltip_text = update_tooltip(card)

func _on_damage_taken_modification_requested(cardUI: CardUI, new_instructions: Array[Callable]) -> void:
	instructions["damage_taken_modifier"] = new_instructions
	var card : Card = cardUI.card
	card.processed_tooltip_text = update_tooltip(card)
	Events.card_tooltip_requested.emit(card.icon, card.processed_tooltip_text)
