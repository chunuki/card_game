extends Control

@onready var deck_panel : Panel = %DeckPanel

# temporarily passed through here only to test
# when you select Warrior and start new game,
# it should instantiate CharacterStats in GameStates
# to not use the base resource
@export var character_stats: CharacterStats

# also temporarily passed through here
# when entering from a save file,
# unlocked stages should not reset like this
@export var unlocked_stages: Array[String]

func _init() -> void:
	GameStates.load_game()

func _ready() -> void:
	get_tree().paused = false
	# for now we instantiate here instead of higher in hierarchy
	if not GameStates.char_stats:
		GameStates.char_stats = character_stats.create_instance()
	if not GameStates.unlocked_stages:
		GameStates.unlocked_stages = unlocked_stages

# Reset Button
func _on_reset_stats_to_default_pressed() -> void:
	GameStates.reset_stats_to_default()

# 
func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		deck_panel.show()
		deck_panel.display_deck()
	else:
		deck_panel.hide()
