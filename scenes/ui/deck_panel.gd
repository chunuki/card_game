extends Panel

@onready var card_grid_container: GridContainer = %CardGridContainer


func display_deck() -> void:
	card_grid_container.display_deck()
