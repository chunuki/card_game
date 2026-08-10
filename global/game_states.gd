extends Node

const SAVE_PATH = "user://save_data.cfg"
const BASE_CHAR_STATS = preload("res://characters/warrior/warrior.tres")

# Character gamestates
var char_stats: CharacterStats

# Individual stage gamestates~
# StageUI stores Stage Attributes: Type (e.g. Combat) & StageEnemyInfo
# StageUI, like an "overseer", also stores Stage Name, ID and Next Stages,
# which are separate from StageEnemyInfo (pure enemy data)
var stages_to_be_unlocked: Array[String]
var stage_enemy_info: StageEnemyInfo # maybe remove?

# Stage select gamestates
var unlocked_stages: Array[String] = ["main001"]

func update_unlocked_stages() -> void:
	for stage: String in stages_to_be_unlocked:
		if stage not in unlocked_stages:
			unlocked_stages.append(stage)

# Save file
func save_game() -> void:
	if not char_stats:
		return
		
	var config := ConfigFile.new()
	
	config.set_value("Player", "max_health", char_stats.max_health)
	config.set_value("Player", "health", char_stats.health)
	config.set_value("Player", "max_mana", char_stats.max_mana)
	config.set_value("Player", "cards_per_turn", char_stats.cards_per_turn)
	
	config.set_value("Stages", "unlocked_stages", unlocked_stages)
	
	var card_paths: Array[String] = []
	for card in char_stats.deck.cards:
		if card and card.resource_path != "":
			card_paths.append(card.resource_path)
	config.set_value("Player", "deck_blueprints", card_paths)
	
	var error = config.save(SAVE_PATH)
	if error != OK:
		print("Failed to save game! Error code: ", error)
	else:
		print("Game saved successfully to: ", SAVE_PATH)


func load_game() -> bool:
	var config := ConfigFile.new()

	var error = config.load(SAVE_PATH)
	if error != OK:
		print("No save file found!")
		return false
		
	char_stats = BASE_CHAR_STATS.duplicate()
	char_stats.max_health = config.get_value("Player", "max_health", 100)
	char_stats.max_mana = config.get_value("Player", "max_mana", 3)
	char_stats.cards_per_turn = config.get_value("Player", "cards_per_turn", 4)
	
	var card_paths = config.get_value("Player", "deck_blueprints", [])
			
	char_stats = char_stats.create_instance()
	char_stats.deck.cards = []
	for path in card_paths:
		if ResourceLoader.exists(path):
			var card_res = load(path) as Card
			char_stats.deck.cards.append(card_res)
	char_stats.health = config.get_value("Player", "health", 100)
	
	unlocked_stages = config.get_value("Stages", "unlocked_stages", ["main001"])
	
	print("Game loaded successfully!")
	return true

func reset_stats_to_default() -> void:
	var default: CharacterStats = load("res://characters/warrior/warrior.tres").duplicate(true)
	char_stats = default.create_instance()
	save_game()
