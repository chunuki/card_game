extends Node2D

@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler
@onready var player: Player = $Player as Player

var char_stats: CharacterStats = GameStates.char_stats
var stage_enemy_info: StageEnemyInfo = GameStates.stage_enemy_info

func _ready() -> void:
	battle_ui.char_stats = char_stats # setter
	player.stats = char_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(battle_ui.action_order_ui.do_turns)
	Events.player_died.connect(_on_player_died)
	
	start_battle()

func start_battle() -> void:
	get_tree().paused = false
	
	MusicPlayer.play(music, true)
	enemy_handler.setup(stage_enemy_info)
	enemy_handler.reset_enemy_actions()
	
	# for now there is only 1 player so i emit this
	Events.entity_instantiated.emit(player)
	battle_ui.action_order_ui.randomise_order()
	
	player_handler.start_battle(player.stats)

func _on_enemy_turn_ended() -> void:
	battle_ui.action_order_ui.randomise_order()
	player_handler.start_turn()
	enemy_handler.update_enemy_tickdowns()
	enemy_handler.reset_enemy_actions()
	print("=================")
	
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		
		if battle_ui:
			battle_ui.status_effects_ui.hide()
			battle_ui.tooltip.hide()
			player_handler.reset_modifications_from_battle()
			GameStates.update_unlocked_stages()
		
		if "card_rewards" in stage_enemy_info:
			for card_reward in stage_enemy_info.card_rewards:
				char_stats.deck.add_card(card_reward)
				Events.card_reward_requested.emit(card_reward)
				
		Events.battle_over_screen_requested.emit("You win!", BattleOverPanel.Type.WIN)
		
func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game over!", BattleOverPanel.Type.LOSE)
