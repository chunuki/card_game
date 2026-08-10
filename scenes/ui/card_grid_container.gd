extends GridContainer

const CARD_UI_SCENE := preload("res://scenes/card_ui/card_ui_simple.tscn")

var x_per_card: float
var card_ui_size_ratio := 25.0/30.0

func display_deck() -> void:
	if not x_per_card:
		var h_separation : float = get("theme_override_constants/h_separation")
		x_per_card = (size.x - h_separation * (columns - 1))/columns
	
	for child in get_children():
		child.queue_free()
		
	for card in GameStates.char_stats.deck.cards:
		var card_ui := CARD_UI_SCENE.instantiate() as CardUISimple
		add_child(card_ui)
		
		card_ui.card = card
		card_ui.custom_minimum_size.y = x_per_card / card_ui_size_ratio
		card_ui.custom_minimum_size.x = x_per_card
