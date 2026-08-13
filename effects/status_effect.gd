class_name StatusEffect
extends Resource

enum Type {
	STRENGTH,
	DEXTERITY,
	VULNERABLE,
	POISON,
	FEARFUL
}
enum EffectType {
	DAMAGE_MODIFIER,
	DAMAGE_TAKEN_MODIFIER,
	NONE
}

@export var type: Type
@export_multiline var description: String
@export var icon_label: Texture2D
@export var effect_type: EffectType
@export var tickdown: bool
@export var count: int = 0

var instruction: Callable

func execute(targets: Array[Node], _count = count) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.add_status_effect(self, _count)

func colorer(string: String) -> String:
	return "[color=\"dfdf44\"]%s[/color]" % string
	
func get_description() -> String:
	return "default: " + description
