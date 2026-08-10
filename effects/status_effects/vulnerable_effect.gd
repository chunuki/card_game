class_name VulnerableEffect
extends StatusEffect

func get_description() -> String:
	return description % [colorer("Vulnerable"), colorer(str(count))]
