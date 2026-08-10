class_name Stage
extends Resource

enum Type {COMBAT, BOSS, EVENT, CHEST}

@export_group("Stage Attributes")
@export var type: Type
@export var stage_info: Resource


func is_enemy_stage() -> bool:
	return type == Type.COMBAT or type == Type.BOSS

func is_boss_stage() -> bool:
	return type == Type.BOSS
