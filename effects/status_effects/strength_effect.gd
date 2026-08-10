class_name StrengthEffect
extends StatusEffect

func get_description() -> String:
	return description % [colorer("Strength"), colorer(str(count))]
