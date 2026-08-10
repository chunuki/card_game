class_name PoisonEffect
extends StatusEffect

func get_description() -> String:
	return description % [colorer("Poison"), colorer(str(count))]
