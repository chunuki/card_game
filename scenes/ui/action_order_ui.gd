class_name ActionOrderUI
extends Control

@onready var action_order_container: ActionOrderContainer = %ActionOrderContainer

var action_order := []
var action_order_index := 0

func _ready():
	Events.entity_instantiated.connect(_on_entity_instantiated)
	Events.entity_action_completed.connect(_on_entity_action_completed)

func _on_entity_instantiated(entity) -> void:
	action_order.append(entity)

func randomise_order() -> void:
	if action_order:
		action_order.shuffle()
	update()
	
func update() -> void:
	action_order = action_order.filter(func(x): return is_instance_valid(x))
	action_order_container.update(action_order)

func do_turns() -> void:
	update()
	if action_order == []:
		return
	action_order[0].do_turn()
	
func _on_entity_action_completed() -> void:
	await get_tree().create_timer(0.2).timeout
	if action_order_index == action_order.size()-1:
		action_order_index = 0
		Events.enemy_turn_ended.emit()
		return
	action_order_index += 1
	var next_entity = action_order[action_order_index]
	if next_entity:
		next_entity.do_turn()
