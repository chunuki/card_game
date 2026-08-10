extends Control

var unlocked_stages : Array[String]

func _ready() -> void:
	unlocked_stages = GameStates.unlocked_stages
	for stage_ui in get_children():
		stage_ui.visible = stage_ui.id in unlocked_stages
		
