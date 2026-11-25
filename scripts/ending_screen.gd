class_name EndingScreen
extends Control

@export var title_label: Label
@export var result_label: Label
@export var restart_button: Button
@export var main_menu_button: Button


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func configure(game_state: GameState) -> void:
	var good := game_state.count_good_shifts()
	var bad := game_state.count_bad_shifts()
	var unknown := game_state.shift_history.size() - good - bad

	if unknown > 0:
		title_label.text = "Week Complete"
	elif good > bad:
		title_label.text = "Good Ending"
	else:
		title_label.text = "Bad Ending"

	result_label.text = (
        "Good shifts: %d\nBad shifts: %d\nUnscored shifts: %d"
		% [good, bad, unknown]
	)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(
        "res://scenes/main_menu.tscn"
	)
