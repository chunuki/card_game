class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

const CARD_REWARD_UI_SCENE := preload("res://scenes/card_ui/card_ui_simple.tscn")

@onready var label: Label = %Label
@onready var label_optional: Label = %LabelOptional
@onready var card_rewards: HBoxContainer = %CardRewards
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton

func _ready() -> void:
	continue_button.pressed.connect(
		func(): get_tree().change_scene_to_file("res://scenes/stage_select/stage_select.tscn")
	)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.battle_over_screen_requested.connect(show_screen)
	Events.card_reward_requested.connect(show_card_reward)
	
	label_optional.text = ""
	for child in card_rewards.get_children():
		child.queue_free()

func show_screen(text: String, type: Type) -> void:
	
	GameStates.save_game()
	
	label.text = text
	continue_button.visible = type == Type.WIN
	restart_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
	
func show_card_reward(card_reward: Card) -> void:
	label_optional.text = "Boss Rewards:"
	var card_reward_ui := CARD_REWARD_UI_SCENE.instantiate() as CardUISimple
	card_rewards.add_child(card_reward_ui)
	card_reward_ui.card = card_reward
