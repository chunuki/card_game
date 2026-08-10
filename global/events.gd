extends Node

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested
signal card_reward_requested(card: Card)
signal card_queued(cardUI: CardUI, targets: Array)
signal card_animation_completed

# Player-related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

# Enemy-related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended

# Entity-related events
signal status_effects_ui_requested(stats: Stats)
signal status_effects_ui_hide_requested
signal entity_instantiated(entity)
signal entity_action_completed
signal entity_visuals_updated

# Battle-related events
signal battle_requested(character_stats: CharacterStats, stage_enemy_info: StageEnemyInfo)
signal battle_started
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)

# Calculation-related events
signal damage_calculation_requested(cardUI: CardUI)
signal instructions_requested(instructions: Dictionary)
signal damage_taken_modification_requested(cardUI: CardUI, instructions: Array[Callable])
