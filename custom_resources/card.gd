class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var number: int
@export var cost: int
@export var status_effect: StatusEffect

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream

var instructions : Dictionary 
var instruction_type : String : get = _get_instruction_type
var processed_tooltip_text: String : get = _get_processed_tooltip_text

func _get_processed_tooltip_text() -> String:
	if processed_tooltip_text:
		return processed_tooltip_text
	return get_default_tooltip_text()

func _get_instruction_type() -> String:
	match type:
		Type.ATTACK: return "damage_modifier"
		Type.SKILL: return "block_modifier"
		Type.POWER: return "damage_modifier"
		_: return "damage_modifier"

func get_default_tooltip_text() -> String:
	if "%d" in tooltip_text:
		return tooltip_text % number
	return tooltip_text

func is_single_targeted() -> bool: # check for single target
	return target == Target.SINGLE_ENEMY

func _get_targets(targets: Array[Node]) -> Array[Node]:
		
	var tree := Engine.get_main_loop() as SceneTree
	if not tree:
		return []
		
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))
	
func apply_effects(_targets: Array[Node]) -> void:
	pass
	
