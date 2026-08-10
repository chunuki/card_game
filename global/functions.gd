extends Node

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func damage_modifier(status_effects: Array[StatusEffect]) -> Array[Callable]:
	var instructions: Array[Callable] = []
	for status in status_effects:
		if status.type == StatusEffect.Type.STRENGTH:
			instructions.append(func(x: int): return x + status.count)
	return instructions
	
func block_modifier(status_effects: Array[StatusEffect]) -> Array[Callable]:
	var instructions: Array[Callable] = []
	for status in status_effects:
		if status.type == StatusEffect.Type.DEXTERITY:
			instructions.append(func(x: int): return x + status.count)
	return instructions
	
func damage_taken_modifier(status_effects: Array[StatusEffect]) -> Array[Callable]:
	var instructions: Array[Callable] = []
	for status in status_effects:
		if status.type == StatusEffect.Type.VULNERABLE:
			instructions.append(func(x: int): return x * 1.5)
	return instructions

func execute_instructions(number: int, instructions: Array) -> int:
	for instruction in instructions:
		number = instruction.call(number)
	return floori(number)
