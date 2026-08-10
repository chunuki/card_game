class_name ActionOrderContainer
extends HBoxContainer

const ENTITY_ICON = preload("res://scenes/ui/entity_icon.tscn")

func update(action_order: Array) -> void:
	for child in get_children():
		child.queue_free()
	for entity in action_order:
		var entity_icon = ENTITY_ICON.instantiate()
		var sprite_2d: Sprite2D = entity.sprite_2d
		entity_icon.texture = sprite_2d.texture
		add_child(entity_icon)
