class_name FearfulEffect
extends StatusEffect

func get_description() -> String:
	return description % [colorer("Fearful"), colorer(str(count))]
