class_name StageUI
extends Control

@export var stage: Stage
@export var stage_name: String
@export var id: String

@export var next_stages: Array[String]

@onready var panel: Panel = $Panel
@onready var stage_label: Label = $StageLabel
@onready var stage_image: TextureRect = $StageImage

const STAGE_IMAGES: Dictionary = {
	Stage.Type.COMBAT: preload("res://art/tile_0103.png"),
	Stage.Type.BOSS: preload("res://art/tile_0107.png"),
	Stage.Type.EVENT: preload("res://art/tile_0082.png"),
	Stage.Type.CHEST: preload("res://art/tile_0089.png"),
}

func _ready() -> void:
	stage_label.text = stage_name
	stage_image.texture = STAGE_IMAGES.get(stage.type)

# perform this if clicked
# check stage type, if it is a battle node
# if battle node, send to battle script
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		GameStates.stages_to_be_unlocked = next_stages
		if stage.is_enemy_stage():
			GameStates.stage_enemy_info = stage.stage_info
			get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
