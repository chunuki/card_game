class_name DexterityEffect
extends StatusEffect

func get_description() -> String:
	return description % [colorer("Dexterity"), colorer(str(count))]
