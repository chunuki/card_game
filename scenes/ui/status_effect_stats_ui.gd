class_name StatusEffectStatsUI
extends HBoxContainer

@onready var status_image : TextureRect = $StatusImage
@onready var status_label : Label = $StatusLabel

var status_effect : StatusEffect
var temp_texture : Texture2D
var temp_label_text : String

func setup_information(effect: StatusEffect) -> void:
	status_effect = effect
	if is_inside_tree():
		status_image.texture = status_effect.icon_label
		status_label.text = str(status_effect.count)
	else:
		temp_texture = status_effect.icon_label
		temp_label_text = str(status_effect.count)

func _ready() -> void:
	if temp_texture:
		status_image.texture = temp_texture
	if temp_label_text:
		status_label.text = temp_label_text

func _on_mouse_entered() -> void:
	var description: String = status_effect.get_description()
	var icon_label: Texture2D = status_effect.icon_label
	Events.status_effects_ui_requested.emit(icon_label, description)

func _on_mouse_exited() -> void:
	Events.status_effects_ui_hide_requested.emit()
